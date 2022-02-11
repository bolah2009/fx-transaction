require 'rails_helper'

describe FX::Regex::Transaction do
  describe '.currency_regex' do
    subject { described_class.currency_regex }

    it { is_expected.to match('USD') }
    it { is_expected.to match('EUR') }
    it { is_expected.to match('CAD') }
    it { is_expected.not_to match('usd') }
    it { is_expected.not_to match('NG@') }
    it { is_expected.not_to match('NG_') }
    it { is_expected.not_to match('U-S') }
    it { is_expected.not_to match('N?G') }
    it { is_expected.not_to match('US1') }
    it { is_expected.not_to match('N') }
    it { is_expected.not_to match('NGNM') }
    it { is_expected.not_to match('dollar') }
    it { is_expected.not_to match('naira') }
    it { is_expected.not_to match('222') }
  end

  describe '.amount_regex' do
    subject { described_class.amount_regex }

    it { is_expected.to match('0.0') }
    it { is_expected.to match('0.00') }
    it { is_expected.to match('0.50') }
    it { is_expected.to match('1.00') }
    it { is_expected.to match('20.01') }
    it { is_expected.to match('333.2') }
    it { is_expected.to match('44929299.39') }
    it { is_expected.to match('82998288.1') }
    it { is_expected.not_to match('1.888') }
    it { is_expected.not_to match('223.333') }
    it { is_expected.not_to match('999299992') }
    it { is_expected.not_to match('999e999.e') }
    it { is_expected.not_to match('fffr44dd') }
    it { is_expected.not_to match('345ffd3') }
    it { is_expected.not_to match('22@3.00') }
    it { is_expected.not_to match('222.4$') }
    it { is_expected.not_to match('0') }
    it { is_expected.not_to match('222') }
  end

  describe '.customer_regex' do
    subject { described_class.customer_regex }

    it { is_expected.to match('sTz') }
    it { is_expected.to match('sT3') }
    it { is_expected.to match('2jkR') }
    it { is_expected.to match('4444') }
    it { is_expected.to match('DzPo') }
    it { is_expected.to match('xqSZp') }
    it { is_expected.to match('VLR8J') }
    it { is_expected.not_to match('D') }
    it { is_expected.not_to match('s') }
    it { is_expected.not_to match('a_') }
    it { is_expected.not_to match('3g') }
    it { is_expected.not_to match('US') }
    it { is_expected.not_to match('ng') }
    it { is_expected.not_to match('gH') }
    it { is_expected.not_to match('8@33') }
    it { is_expected.not_to match('Zq_tZ') }
    it { is_expected.not_to match('UH*7L') }
    it { is_expected.not_to match('7?{Eh') }
    it { is_expected.not_to match('222.4$') }
    it { is_expected.not_to match('22@3.00') }
    it { is_expected.not_to match('Pyk02f?') }
    it { is_expected.not_to match('Q6uFlW') }
    it { is_expected.not_to match('XsZ_25wv') }
    it { is_expected.not_to match('yRO44WEjV') }
    it { is_expected.not_to match('fffr44dd') }
    it { is_expected.not_to match('345ffd3') }
  end
end
