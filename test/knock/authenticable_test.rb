require 'test_helper'
require 'jwt'
require 'timecop'

module Knock
    class DummyUser
    end
    
    class Request
        attr_reader :headers
        def initialize(headers:)
            @headers = headers
        end
    end
    class DummyClass
      include Knock::Authenticable
      
      attr_reader :params, :request
  
      def initialize(params:, request:)
        @params = params
        @request = request
      end
      
      def authenticate
          authenticate_for DummyUser   
      end
    end
  class AuthenticableTest < ActiveSupport::TestCase
    
    test 'throw exception when token empty' do
        dummy = Knock::DummyClass.new(params: { token: nil }, request: Request.new(headers:{ 'Authorization' => nil }))
        assert_raises(AuthenticationError) {
            dummy.authenticate
        }
    end

    test 'throw exception when token wrong' do
        dummy = Knock::DummyClass.new(params: { token: nil }, request: Request.new(headers:{ 'Authorization' => 'Bearer aud.exp' }))
        assert_raises(AuthenticationError) {
            dummy.authenticate
        }
    end

    test 'throw exception when token is expired' do
        token =
        JWT.encode(
          {sub: '1', exp: Knock.token_lifetime},
          Knock.token_secret_signature_key.call,
          Knock.token_signature_algorithm
        )
        dummy = Knock::DummyClass.new(params: { token: nil }, request: Request.new(headers:{ 'Authorization' => token }))
        Timecop.travel(25.hours.from_now) do
        assert_raises(AuthenticationError) {
            dummy.authenticate
        }
    end
    
  end
  end
end