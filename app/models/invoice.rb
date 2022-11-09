class Invoice < ActiveRecord::Base
  include AASM  

  aasm column: :state, whiny_transitions: false do
    state :sleeping, initial: true, before_enter: :before_sleeping
    state :running, before_enter: Proc.new { do_something && notify_somebody } 
    state :cleaning
    state :finished

    after_all_transitions :log_status_change

    event :run, after: :notify_somebody do
      before do
        puts 'before run'
      end

      transitions from: :sleeping, to: :running, after: Proc.new {|*args| set_process(*args) }
      transitions from: :running, to: :finished
    end

    event :sleep do
      after do
        puts 'after sleep'
      end
      error do |e|
        puts 'sleep error'
      end
      transitions from: :running, to: :sleeping
    end

    event :clean do
      transitions from: :running, to: :cleaning
    end

    #event :run do
    #  transitions from: :sleeping, to: :running
    #end

    #event :sleep do
    #  transitions from: [:running, :cleaning], to: :sleeping
    #end
  end

  def set_process(name)
    puts 'process: ' + name
  end

  def before_sleeping
    puts 'before_sleeping'
  end

  def do_something
    puts 'do_something'
  end

  def notify_somebody
    puts 'notify_somebody'
  end

  def log_status_change
    puts "changing from #{aasm.from_state} to #{aasm.to_state} (event: #{aasm.current_event})"
  end
  
end

# == Schema Information
#
# Table name: invoices
#
#  id         :integer         not null, primary key
#  state      :string
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

