describe 'Yoti::AgeProcessor' do
    describe '.is_age_verification' do
        context 'returns true when field name is age_over|under' do
            it 'should return true as value' do
                expect(Yoti::AgeProcessor.is_age_verification('age_over:18')).to eql(true)
                expect(Yoti::AgeProcessor.is_age_verification('age_under:18')).to eql(true)
            end
        end

        context 'returns false when field name is no age_over|under' do
            it 'should return false as value' do
                expect(Yoti::AgeProcessor.is_age_verification('given_names')).to eql(false)
            end
        end
    end
end