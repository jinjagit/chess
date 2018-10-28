module Position
  def self.get_posn(name)
    if name == 'start'
      # position at new game start:
      posn = ['br', 'bn', 'bb', 'bq', 'bk', 'bb', 'bn', 'br',
                'bp', 'bp', 'bp', 'bp', 'bp', 'bp', 'bp', 'bp',
                '--', '--', '--', '--', '--', '--', '--', '--',
                '--', '--', '--', '--', '--', '--', '--', '--',
                '--', '--', '--', '--', '--', '--', '--', '--',
                '--', '--', '--', '--', '--', '--', '--', '--',
                'wp', 'wp', 'wp', 'wp', 'wp', 'wp', 'wp', 'wp',
                'wr', 'wn', 'wb', 'wq', 'wk', 'wb', 'wn', 'wr']
    end
  end
end
