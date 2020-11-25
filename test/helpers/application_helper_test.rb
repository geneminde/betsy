require "test_helper"

describe ApplicationHelper, :helper do
  describe 'readable_date' do
    it "produces a tag with the full timestamp" do
      date = Date.today - 14

      result = readable_date(date)

      expect(result).must_include date.to_s
    end

    it "returns [unknown] if the date is nil" do
      date = nil

      result = readable_date(date)

      expect(result).must_equal "[unknown]"
    end
  end

  describe 'readable_time' do
    it 'produces a tag with the timestamp' do
      date_time = DateTime.now

      result = readable_date(date_time)

      expect(result).must_include date_time.to_s
    end

    it 'returns [unknown] if the date is nil' do
      date_time = nil

      result = readable_date(date_time)

      expect(result).must_equal "[unknown]"
    end
  end
end