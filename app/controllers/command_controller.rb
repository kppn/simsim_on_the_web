class CommandController < ApplicationController
  skip_before_action :verify_authenticity_token

  # POST /command
  # POST /command.json
  def create
    puts params['kind']
    puts params['event_socket']
    puts params['name']
    puts params['value']

    value = if params['value']
              if params['value'] =~ /\A[0-9]+\z/
                params['value'].to_i
              else
                params['value'].to_f
              end
            else
              params['value']
            end

    cmd = "/usr/bin/env ruby #{Rails.root}/lib/simsim/cmd #{params['event_socket']} #{params['kind']} #{params['name']} #{value}"
    puts "========"
    p cmd
    puts `#{cmd}`
    puts "========"

    respond_to do |format|
      format.json{ render :json => {} }
    end
  end

  private
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
        "peer :#{name}, '#{own_ip}:#{own_port}', '#{dst_ip}:#{dst_port}', #{protocol}"
      }.join("\n")
      conf_str += "\n\n"

      conf_str
    end

    def start_simsim(params)
      params = to_hash(params)
      config_file   = save_tempfile('config_', config_json_to_string(params['config']))
      scenario_file = save_tempfile('scenario_', params['scenario'])

      spawn("#{Rails.root}/lib/sender.rb #{params['client_id']} #{config_file.path} #{scenario_file.path}")
    end

    def stop_simsim(params)
      pid = JSON.parse(params.keys.first)['pid']
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
