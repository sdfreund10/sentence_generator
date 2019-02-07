# frozen_string_literal: true

require 'minitest/autorun'
require 'webmock/minitest'

class TestSetup < MiniTest::Test
  PATHS = %w[
    Harry%20Potter%201%20-%20Sorcerer's%20Stone.txt
    Harry%20Potter%202%20-%20Chamber%20of%20Secrets.txt
    Harry%20Potter%203%20-%20The%20Prisoner%20Of%20Azkaban.txt
    Harry%20Potter%204%20-%20The%20Goblet%20Of%20Fire.txt
    Harry%20Potter%205%20-%20Order%20of%20the%20Phoenix.txt
    Harry%20Potter%206%20-%20The%20Half%20Blood%20Prince.txt
    Harry%20Potter%207%20-%20Deathly%20Hollows.txt
  ].freeze

  def test_setup_pulls_hp_files
    WebMock.disable_net_connect!
    suppress_output do
      preserve_texts do
        PATHS.each do |path|
          stub_request(
            :get,
            URI('http://www.glozman.com/TextPages/' + path)
          ).to_return(body: '')
        end
        load(__dir__ + '/../bin/setup')

        PATHS.each do |path|
          assert_requested :get, 'http://www.glozman.com/TextPages/' + path
        end
      end
    end
  end

  def suppress_output
    old_stdout = $stdout
    $stdout = File.open(File::NULL, 'w')

    yield

    $stdout = old_stdout
  end

  def preserve_texts
    Dir[__dir__ + '/../texts/*.txt'].each do |file|
      FileUtils.mv(file, file + '.copy')
    end

    yield
  ensure
    Dir[__dir__ + '/../texts/*.txt.copy'].each do |file|
      FileUtils.mv(file, file.gsub('.copy', ''))
    end
  end
end
