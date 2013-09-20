require 'mechanize'

class BZOJSmt
  def initialize
    puts "Initialize BZOJSmt."
    @agent = Mechanize.new
    @agent.get("http://www.lydsy.com/")
    @agent.post("http://www.lydsy.com/JudgeOnline/login.php",{
        'user_id'=>"submittersubmitter",
        'password'=>"123456",
        "submit"=>"Submit"})
    @agent.cookie_jar.save_as("cookie")
    puts "Comlete."
  end

  def to_n(language)
    language.downcase!
    if language=="c"||language=='0'
      0
    elsif language=="c++"||language=='1'
      1
    elsif language=="pascal"||language=='2'
      2
    elsif language=="java"||language=='3'
      3
    elsif language=="ruby"||language=='4'
      4
    elsif language=="bash"||language=='5'
      5
    elsif language=="python"||language=='6'
      6
    end
  end

  def get_run_id(id, language=1)
    page=@agent.get('http://www.lydsy.com/JudgeOnline/status.php?problem_id='+id.to_s+
      '&user_id=submittersubmitter&language='+language.to_s+'&jresult=-1')
    status=page.body
    /\d+/.match(/<td>\d+<td>/.match(status).to_s).to_s.to_i
  end

  def submit(id, path, language=1)
    code=""
    File.open(path) do |file|
      file.each_line{|line|code+=line}
    end

    @agent.post("http://www.lydsy.com/JudgeOnline/submit.php",{
        'id'=>id,
        'source'=>code,
        'language'=>language})

    get_run_id(id, language)
  end

  def get_status(name,res)
    return "N/A" unless (res=~/#{name}:[a-zA-Z0-9 ]/)
    tr=/#{name}:[a-zA-Z0-9_ ]{4,}/.match(res).to_s
    tr["#{name}:"]=""
    tr
  end

  def trace_status(id)
    res=@agent.get('http://www.lydsy.com/JudgeOnline/showsource.php?id='+id.to_s).body
#puts(status)
    status={}
    status[:result]=get_status('Result',res)
    status[:memory]=get_status('Memory',res)
    status[:time]=get_status('Time',res)
    status
  end
end

smt=BZOJSmt.new
#smt.submit(1000,"t.cpp")
#puts smt.get_run_id(1000)
#puts smt.trace_status(481234)

loop do
  order=gets.downcase.split(' ');
  if order[0]=='submit'
    puts smt.submit(order[1],order[2],smt.to_n(order[3]))
  elsif order[0]=='trace'
    status=smt.trace_status(order[1]);
    puts "result:\t"+status[:result]
    puts "memory:\t"+status[:memory]
    puts "time:\t"+status[:time]
  elsif order[0]=="exit"
    break
  end
end
