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
    elsif name == 'dbl_checks'
      posn = ['bq', '--', '--', '--', '--', 'br', 'bk', 'br',
              '--', '--', '--', '--', '--', 'bp', 'bq', 'bp',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', 'wq', '--',
              '--', '--', '--', '--', '--', '--', 'wr', '--',
              '--', '--', '--', '--', '--', '--', 'wk', '--']
    elsif name == 'castling'
      posn = ['--', '--', '--', '--', 'br', 'bk', 'br', '--',
              '--', '--', '--', '--', 'bp', '--', 'bp', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              'bb', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              'wr', '--', '--', '--', 'wk', '--', '--', 'wr']
    elsif name == 'crash'
      posn = ['br', '--', '--', '--', 'bk', 'bb', 'bn', 'br',
              'bp', 'bp', 'bp', 'bq', 'bp', 'bp', 'bp', '--',
              '--', '--', 'bn', '--', '--', '--', '--', '--',
              '--', 'wb', '--', '--', 'wn', '--', '--', '--',
              '--', '--', '--', '--', 'bp', '--', 'wq', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              'wp', 'wp', 'wp', 'wp', '--', 'wp', 'wp', 'wp',
              'wr', 'wn', 'wb', '--', 'wk', '--', '--', 'wr']
    elsif name == 'bishops'
      posn = ['--', '--', '--', '--', 'bk', '--', '--', '--',
              '--', 'bb', 'bb', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              'wb', '--', 'wb', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', 'wb', '--',
              'wb', '--', 'wb', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', 'wk', '--', '--', '--']
    elsif name == 'queens'
      posn = ['--', '--', '--', '--', 'bk', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', 'bq', '--', '--', '--', '--', '--', 'wq',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', 'wq', '--', '--', '--', 'wq',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', 'wq',
              '--', '--', '--', '--', 'wk', '--', '--', '--']
    elsif name == 'stalemate'
      posn = ['--', '--', '--', '--', '--', '--', 'bk', '--',
              '--', '--', '--', '--', '--', '--', 'wp', '--',
              '--', '--', '--', '--', '--', '--', 'br', 'wp',
              '--', '--', '--', '--', '--', 'wk', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--']
    elsif name == 'checks'
      posn = ['--', '--', '--', '--', 'bn', '--', 'bk', '--',
              '--', 'br', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', 'wp', 'wp', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', 'bb',
              '--', '--', '--', '--', 'wn', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', 'bp',
              '--', '--', '--', '--', '--', 'wr', 'bp', '--',
              '--', 'wb', '--', '--', '--', '--', 'wk', '--']
    elsif name == 'promote'
      posn = ['--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--',
              'wp', 'wp', 'wp', 'wp', 'wp', 'wp', 'wp', 'wp',
              '--', '--', '--', '--', '--', 'wk', '--', '--',
              '--', '--', 'bk', '--', '--', '--', '--', '--',
              'bp', 'bp', 'bp', 'bp', 'bp', 'bp', 'bp', 'bp',
              '--', '--', '--', '--', '--', '--', '--', '--',
              '--', '--', '--', '--', '--', '--', '--', '--']
    end
  end
end
