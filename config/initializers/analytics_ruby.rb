Analytics = Segment::Analytics.new({
    write_key: 'mjntOqQUPo5B1aLp2Qb60irCeW2viGB3',
    on_error: Proc.new { |status, msg| print msg }
})