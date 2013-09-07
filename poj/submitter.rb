require 'mechanize'

class POJSmt
  def initialize
    puts "Initialize POJSmt."
    @agent = Mechanize.new
    @agent.get("http://poj.org")
    @agent.post("http://poj.org/login",{
        'user_id1'=>"submittersubmitter",
        'password1'=>"123456",
        'B1'=>'login'})
    @agent.cookie_jar.save_as("cookie")
    puts "Comlete."
  end

  def get_run_id(id, language=0)
    page=@agent.get('http://poj.org/status?problem_id='+id.to_s+
            '&user_id=submittersubmitter&language='+language.to_s)
    status=page.body
    /\d+/.match(/<tr align=center><td>\d+<\/td>/.match(status).to_s).to_s.to_i
  end

  def submit(id, path, language=0)
    code=""
    File.open(path) do |file|
      file.each_line{|line|code+=line}
    end

    page=@agent.get("http://poj.org/submit")
    f=page.form_with(:method=>"POST")
    f['problem_id']=id.to_s
    f['source']=code
    f.click_button

    get_run_id(id, language)
  end

  def get_status(name,res)
    tr=/#{name}.+<\/td>/.match(res)
    tr=/>[a-zA-Z0-9 \/]{4,}</.match(tr.to_s)
    /[a-zA-Z0-9 \/]{4,}/.match(tr.to_s)
  end

  def trace_status(id)
    res=@agent.get('http://poj.org/showsource?solution_id='+id.to_s).body
#puts(status)
    status={}
    status[:result]=get_status('Result',res)
    status[:memory]=get_status('Memory',res)
    status[:time]=get_status('Time',res)
    status
  end
end

smt=POJSmt.new
#smt.submit(1000,"tp.cpp")
#puts smt.get_run_id(1000)
puts smt.trace_status(12086438)
