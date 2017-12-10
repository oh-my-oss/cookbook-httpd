package "mod24_ssl" do
    action :install
end

strength = 2048
serial = 0
days = 3650
subject = "/C=JP/CN=localhost"
crt_file = "/etc/pki/tls/certs/localhost.crt"
key_file = "/etc/pki/tls/private/localhost.key"
crt_and_key_file = "/etc/pki/tls/private/localhost.crt_and_key"

template "/etc/httpd/conf.d/ssl.conf" do
    owner "root"
    mode 0644
    source "ssl.conf.erb"
end

bash "create_self_signed_cerficiate" do
    code <<-EOH
        openssl req -new -newkey rsa:#{strength} -sha1 -x509 -nodes \
            -set_serial #{serial} \
            -days #{days} \
            -subj "#{subject}" \
            -out "#{crt_file}" \
            -keyout "#{key_file}" &&
            cat "#{crt_file}" "#{key_file}" >> "#{crt_and_key_file}" &&
            chmod 400 "#{key_file}" "#{crt_and_key_file}"
    EOH
    creates crt_and_key_file
    notifies :reload, 'service[httpd]'
end
