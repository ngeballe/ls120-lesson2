class State
  attr_accessor :name, :clinton, :trump, :lead, :electoral_votes

  def initialize(row_data)
    @name = row_data[/[a-z\s]+/i].strip
    @clinton, @trump, @lead, @electoral_votes = row_data.gsub(name, "").strip.split
    self.electoral_votes = electoral_votes.to_i
    # self.clinton = (clinton.to_f) / 100
    # self.trump = (trump.to_f) / 100
    self.lead = (lead.to_f) / 100
  end

  def winner
    if @lead > 0
      "Clinton"
    elsif @lead < 0
      "Trump"
    end
  end
end

class Clinton

end

class Trump
end

class Forecast
  attr_accessor :states

  def initialize(filename)
    @data = File.readlines(filename)
    @states = []
  end

  def generate_state_data
    @data[1..-1].each do |line|
      @states << State.new(line)
    end
  end

  def tally_vote_forecast
    generate_state_data
    clinton_ev = 0
    trump_ev = 0
    # see who wins each state
    @states.each do |state|
      if state.winner == "Clinton"
        clinton_ev += state.electoral_votes
      elsif state.winner == "Trump"
        trump_ev += state.electoral_votes
      end
    end
    puts clinton_ev
    puts trump_ev
  end
end

f = Forecast.new('data.txt').tally_vote_forecast
