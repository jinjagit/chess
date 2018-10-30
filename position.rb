module Position
  def self.get_posn(name)
    if name == 'start' # position at new game start:
      posn = ['br', 'bn', 'bb', 'bq', 'bk', 'bb', 'bn', 'br',
              'bp', 'bp', 'bp', 'bp', 'bp', 'bp', 'bp', 'bp',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              'wp', 'wp', 'wp', 'wp', 'wp', 'wp', 'wp', 'wp',
              'wr', 'wn', 'wb', 'wq', 'wk', 'wb', 'wn', 'wr']
    elsif name == 'two_pawns'
      posn = ['--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', 'bp', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', 'wp', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--']
    elsif name == 'four_rooks'
      posn = ['--', '--', '--', '--', 'bk', '--', '--', 'br',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              'br', '--', '--', '--', 'wr', '--', '--', 'wr',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', 'wk', '--', '--', '--']
    elsif name == 'four_knights'
      posn = ['--', 'bn', '--', '--', '--', '--', 'bn', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', 'wn', '--', '--', '--', '--', 'wn', '--']
    elsif name == 'four_bishops'
      posn = ['--', '--', '--', '--', 'bk', '--', '--', '--',
              '--', 'bb', 'bb', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              'wb', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', 'wb', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', 'wk', '--', '--', '--']
    elsif name == 'two_queens'
      posn = ['--', '--', '--', '--', 'bk', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', 'bq', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', 'wq', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', 'wk', '--', '--', '--']
    elsif name == 'two_kings'
      posn = ['--', '--', '--', '--', 'bk', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', 'wr', '--', '--', '--',
              '--', '--', '--', 'bn', 'wk', '--', '--', '--']
    end
  end
end
