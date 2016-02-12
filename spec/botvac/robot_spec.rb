require "spec_helper"

describe Botvac::Robot::Hmac do
  subject do
    described_class.new(
      double('app', call: {}),
      serial: "OPS39348-C0BCB237AC0F",
      secret: "702FA35268D2792B2AAF9510B47756D8",
    )
  end

  let(:env) { { request_headers: {}, 'body' => '{"reqId":"1","cmd":"getRobotState"}'  } }

  it 'adds the HMAC signature to the authorization header' do
    Timecop.freeze(Time.parse("Tue, 09 Feb 2016 18:06:56 GMT")) do
      expect{ subject.call(env) }.to change{ env[:request_headers]['Authorization'] }.to include("f93e6a50c3134706ae875adfabc9a14f0cc61e1b11b111499b4e6eeb1f69da70")
    end
  end

  it 'sets the date header' do
    Timecop.freeze(Time.parse("Tue, 09 Feb 2016 18:06:56 GMT")) do
      expect{ subject.call(env) }.to change{ env[:request_headers]['Date'] }.to("Tue, 09 Feb 2016 18:06:56 GMT")
    end
  end
end
