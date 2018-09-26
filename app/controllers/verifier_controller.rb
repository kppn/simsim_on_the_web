require 'open3'

class VerifierController < ApplicationController
  skip_before_action :verify_authenticity_token

  # POST verifiers
  # POST verifiers.json
  def create
    content = params[:verifier][:content]

    stat, out, err = verify(content)

    json = {
      stat: stat,
      out: out,
      err: exclude_script_path(err)
    }

    respond_to do |format|
      format.json { render json: json, status: 200 }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def verifier_params
      params.require(:verifier).permit(:content)
    end

    def verify(content)
      out = err = stat = nil

      Tempfile.open('scenario_', "#{Rails.root}/tmp/scenarios") do |file|
        file.puts content
        file.flush

        cmd = "ruby -c #{file.path}"
        Open3.popen3(cmd) do |stdin, stdout, stderr, thr|
          out = stdout.read
          err = stderr.read
          stat = thr.value
        end
      end

      [stat.exitstatus, out, err]
    end

    def exclude_script_path(s)
      s.sub %r{\A[/0-9a-zA-Z_\-]+:}, ''
    end
end
