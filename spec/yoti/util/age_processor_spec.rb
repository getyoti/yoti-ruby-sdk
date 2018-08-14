describe 'Yoti::AgeProcessor' do
    describe '.has_age_condition' do
        context 'when there is age_over|under attribute present' do
            it 'should return true as value' do
                expect(Yoti::AgeProcessor.has_age_condition('age_over:18')).to eql(true)
            end
        end

        context 'when there is no age_over|under attribute present' do
            it 'should return false as value' do
                expect(Yoti::AgeProcessor.has_age_condition('age_test:18')).to eql(false)
            end
        end
    end
end