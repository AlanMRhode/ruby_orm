#Alan Rhode

#Ruby ORM

class User

	attr_accessor :fname, :lname, :email

	def initialize(fname=" ", lname=" ", email=" ")
		@fname = fname
		@lname = lname
		@email = email
	end

	def save
		puts `psql -d orm -c "INSERT INTO users (fname, lname, email) VALUES ('#{@fname}', '#{@lname}', '#{@email}');"`
	end

	def self.find(search_id)
		command = `psql -d orm -c "SELECT * FROM users WHERE id = '#{search_id}';"`
		sql_results_parser command
	end

	def self.where(hash={})
		if hash[:fname]
			command = `psql -d orm -c "SELECT * FROM users WHERE fname = '#{hash[:fname]}';"`
			sql_results_parser command
		elsif hash[:lname]
			command = `psql -d orm -c "SELECT * FROM users WHERE lname = '#{hash[:lname]}';"`
			sql_results_parser command
		elsif hash[:email]
			command = `psql -d orm -c "SELECT * FROM users WHERE email = '#{hash[:email]}';"`
			sql_results_parser command
		end
	end

	def self.all
		command = `psql -d orm -c "SELECT * FROM users"`
		sql_results_parser command
	end

	def self.sql_results_parser(command)
	    my_arr=[]
	    my_hash={}
	    where_arr=[]
	    split = command.split()
	    for i in 0..split.length
	    	if i%2 == 0
	    		my_arr << split[i]
	    	end
	    end

	    my_arr.pop(2)

	    first5 = my_arr[0]
	    for i in 5...my_arr.length
	    	my_hash[first5.to_sym] = my_arr[i]
	    		first5 = my_arr[i%5+1]
	    		if first5 == my_arr[5]
	    			where_arr << my_hash
	    			my_hash={}
	    			first5 = my_arr[0]
	    		end
	    	end

	    if where_arr.length == 1
	    	p = User.new(where_arr[0][:fname], where_arr[0][:lname], where_arr[0][:email])
	   		return p
	    else
	    	f = []
	    	where_arr.each do |object|
	    		p = User.new(object[:fname], object[:lname], object[:email])
	    	 	f.push p
	    	end
	    	 f
	    end
	end

	def self.last
		command = `psql -d orm -c "SELECT * FROM users ORDER BY id DESC LIMIT 1";`
		sql_results_parser command
	end

	def self.first
		command = `psql -d orm -c "SELECT * FROM users ORDER BY id LIMIT 1";`
		sql_results_parser command
	end

	def self.create(hash={})
		cmd = `psql -d orm -c "INSERT INTO users (fname, lname, email) VALUES ('#{hash[:fname]}', '#{hash[:lname]}', '#{hash[:email]}');"`
	end

	def self.destroy(id)
		`psql -d orm -c "DELETE FROM users WHERE id='#{id}'"`
	end

	def self.destroy_all
		`psql -d orm -c "DELETE FROM users"`
	end
end