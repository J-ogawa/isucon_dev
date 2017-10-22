def pretty_print_log(k, v)
  line = [
    k.ljust(40),
    v[:count].to_s.ljust(5),
    v[:upstream_response_time].round(5).to_s.ljust(10),
    (v[:size]*1.0/v[:count]).round(5).to_s.ljust(10),
    v[:status]
  ].join("\t")
  puts line
end

def path_key(record)
  if record['method'] == 'GET' && record['path'].match(/^\/icons\//)
    "[G]ICONS"
  elsif record['method'] == 'GET' && record['path'].match(/^\/history\/[0-9]+/)
    "[G]HISTORY"
  elsif record['method'] == 'GET' && record['path'].match(/^\/message\?/)
    "[G]MESSAGE"
  elsif record['method'] == 'GET' && record['path'].match(/^\/channel\/[0-9]+/)
    "[G]CHANNEL"
  elsif record['method'] == 'GET' && record['path'].match(/^\/profile/)
    "[G]PROFILE"
  elsif record['method'] == 'GET' && record['path'].match(/^\/posts\/[0-9]+/)
    "[G]USER post"
  else
    "#{record['method']}-#{record['path']}"
  end
end

cnt = 0
path_info = {}
STDIN.each_line do |line|
  record = Hash[line.split("\t").map{ |f| f.split(":", 2) }]
  cnt += 1

  endpoint = path_key(record)
  path_info[endpoint] ||= {
    count: 0,
    size: 0,
    status: {},
    request_time: 0,
    upstream_response_time: 0
  }

  path_info[endpoint][:count] += 1
  path_info[endpoint][:size] += record['size'].to_i
  path_info[endpoint][:status][record['status']] ||= 0
  path_info[endpoint][:status][record['status']] += 1
  path_info[endpoint][:request_time] += record['request_time'].to_f
  path_info[endpoint][:upstream_response_time] += record['upstream_response_time'].to_f
end

# count
puts "[by request count]==============================================================="
path_info.sort_by { |k, v| -v[:count] }.each do |k, v|
  pretty_print_log(k, v)
end

# total elapsed
puts "[by elapsed time]==============================================================="
path_info.sort_by { |k, v| -v[:upstream_response_time] }.each do |k, v|
  pretty_print_log(k, v)
end
puts "[summary]==============================================================="
puts "total #{cnt} records"
['200', '302', '403', '404', '500', '502', '503'].each do |status|
  count = path_info.map { |k, v| v[:status][status] || 0 }.reduce(:+)
  puts "#{status} => #{count}"
end
