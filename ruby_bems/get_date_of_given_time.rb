

def get_schedule_datetime(sch_time="+5 min")
  sch_params = sch_time.split(' ')
  if sch_params.size == 2
    schtime_opt = "#{sch_params[0]}"[0]
    if schtime_opt.eql?('+') or schtime_opt.eql?('-')
      schtime_sec = "#{sch_params[0]}"[1..-1].to_i
    else
      puts "Schedule option was not given. assume '+'"
      schtime_opt = '+'
      schtime_sec = sch_params[0].to_i
    end
    puts "Schedule option: #{schtime_opt}"
    puts "Schedule time  : #{schtime_sec}"
    case "#{sch_params[1]}"
      when 'min','mins','minute','minutes'
	schtime_sec *= 60
      when 'hr','hrs','hour','hours'
        schtime_sec *= 60 * 60
      when 'd','ds','day','days'
        schtime_sec *= 60 * 60 * 24
      when 'm','ms','month','months'
        schtime_sec *= 60 * 60 * 24 * 30
      when 'y','ys','year','years'
        schtime_sec *= 60 * 60 * 24 * 30 * 365
      else
        puts "Unsupported schedule time option #{sch_params[1]}"
	puts "Only min(s)/hr(s)/day(s)/year(s) are supported at this time by CLAF. assume min"
	schtime_sec *= 60
    end
    ##Get Date now.
    tnow    = Time.now.utc.to_i
    schtime = Time.at((schtime_opt.eql?('+'))? tnow + schtime_sec : tnow - schtime_sec)
    puts tnow
    puts schtime.strftime("%Y-%m-%d %H:%M:%S")
  end
end

puts "============================="
get_schedule_datetime("+5 min")
puts "============================="
get_schedule_datetime("-100 min")
puts "============================="
get_schedule_datetime("11 min")
get_schedule_datetime("1 day")
get_schedule_datetime("1 month")
