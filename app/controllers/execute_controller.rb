class ExecuteController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    start_receiver

    respond_to do |format|
      format.json{ render :json => {client_id: Random.rand(10000000)}.to_json }
    end
  end

  # POST /execute
  # POST /execute.json
  def create
    if params[:command] == 'start'
      pid = start_simsim params

      respond_to do |format|
        format.json{ render :json => {pid: pid} }
      end
    else
      pid = stop_simsim params

      respond_to do |format|
        format.json{ render :json => {pid: pid} }
      end
    end
#    @scenario = Scenario.new(scenario_params)
#
#    respond_to do |format|
#      if @scenario.save
#        format.html { redirect_to @scenario, notice: 'Scenario was successfully created.' }
#        format.json { render :show, status: :created, location: @scenario }
#      else
#        format.html { render :new }
#        format.json { render json: @scenario.errors, status: :unprocessable_entity }
#      end
#    end
  end

  private
    def start_receiver
      receiver_pid = `ps aux | grep receiver.rb | grep -v grep | awk '{print $2}'`
      if receiver_pid.nil? || receiver_pid.empty?
        spawn "#{Rails.root}/lib/receiver.rb"
      end
    end

    def save_tempfile(prefix, content)
      Tempfile.create([prefix, '.rb']).tap do |fp|
        fp.print content
        fp.flush
      end
    end

    def to_array(a)
      h = []
      a.each do |v|
        if v.respond_to?(:keys)
          h << to_hash(v)
        elsif v.respond_to?(:zip)
          h << to_array(v)
        else
          h << v
        end
      end
      h
    end

    def to_hash(params)
      h = {}
      params.keys.each do |key|
        if params[key].respond_to?(:keys)
          h[key] = to_hash(params[key])
        elsif params[key].respond_to?(:zip)
          h[key] = to_array(params[key])
        else
          h[key] = params[key]
        end
      end
      h
    end

    def config_json_to_string(config)
      conf = config['config']
      conf_str = ''

      conf_str += "log '#{conf['log_title']}'\n" unless conf['log_title'].empty?
      conf_str += conf['peers'].map{|peer|
        name, own_ip, own_port, dst_ip, dst_port, protocol =
          peer.fetch_values('name', 'own_ip', 'own_port', 'dst_ip', 'dst_port', 'protocol')
        if name
          "peer :#{name}, '#{own_ip}:#{own_port}', '#{dst_ip}:#{dst_port}', #{protocol}"
        else
          "peer '#{own_ip}:#{own_port}', '#{dst_ip}:#{dst_port}', #{protocol}"
        end
      }.join("\n")
      conf_str += "\n\n"

      conf_str
    end

    def default_required_protcols
      [
        "require_relative '#{Rails.root}/lib/default_protocol/lora/protocol'",
        "require_relative '#{Rails.root}/lib/default_protocol/packet_forwarder/protocol'",
        "require_relative '#{Rails.root}/lib/default_protocol/raw'"
      ].join("\n")
    end

    def start_simsim(params)
      params = to_hash(params)

      full_config = [
        params['extra'],
        default_required_protcols,
        config_json_to_string(params['config'])
      ].join("\n")

      config_file   = save_tempfile 'config_', full_config
      scenario_file = save_tempfile 'scenario_', params['scenario']

      spawn "#{Rails.root}/lib/sender.rb #{params['client_id']} #{config_file.path} #{scenario_file.path}"
    end

    def stop_simsim(params)
      pid = JSON.parse(params.keys.first)['pid']

      if `pgrep -P #{pid}`.empty?
        return 0
      end

      child_pid = `pgrep -P #{pid}`
      if child_pid.chomp
        `kill -9 #{child_pid.chomp}`
      end
      if pid
        `kill -9 #{pid} #{pid}`
      end

      Process.wait pid

      pid
    end

end
