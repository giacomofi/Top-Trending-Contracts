['pragma solidity ^0.4.23;\n', '\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a / b;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', 'contract Token {\n', ' \n', '  function transferFrom(address from, address to, uint256 tokens) public returns (bool success);\n', '\n', '  function transfer(address to, uint256 tokens) public returns (bool success);\n', '     \n', '}\n', '\n', 'contract BancorKillerContract { \n', '\n', '  using SafeMath for uint256;\n', '\n', '\n', '  address public admin;\n', '\n', '  address public base_token;\n', '\n', '  address public traded_token;\n', '\n', '  \n', '  uint256 public base_token_seed_amount;\n', '\n', '  uint256 public traded_token_seed_amount;\n', '  \n', '  uint256 public commission_ratio;\n', '\n', '\n', '  bool public base_token_is_seeded;\n', '\n', '  bool public traded_token_is_seeded;\n', '  \n', '\n', '  mapping (address => uint256) public token_balance;\n', '\n', '  constructor(address _base_token, address _traded_token,uint256 _base_token_seed_amount, uint256 _traded_token_seed_amount, uint256 _commission_ratio) public {\n', '      \n', '    admin = tx.origin;  \n', '      \n', '    base_token = _base_token;\n', '    \n', '    traded_token = _traded_token;\n', '    \n', '    base_token_seed_amount = _base_token_seed_amount;\n', '    \n', '    traded_token_seed_amount = _traded_token_seed_amount;\n', '\n', '    commission_ratio = _commission_ratio;\n', '    \n', '  }\n', '  \n', '  function transferTokensThroughProxyToContract(address _from, address _to, uint256 _amount) private {\n', '\n', '    token_balance[traded_token] = token_balance[traded_token].add(_amount);\n', '\n', '    require(Token(traded_token).transferFrom(_from,_to,_amount));\n', '     \n', '  }  \n', '\n', '  function transferTokensFromContract(address _to, uint256 _amount) private {\n', '\n', '    token_balance[traded_token] = token_balance[traded_token].sub(_amount);\n', '\n', '    require(Token(traded_token).transfer(_to,_amount));\n', '     \n', '  }\n', '\n', '  function transferETHToContract() private {\n', '\n', '    token_balance[0] = token_balance[0].add(msg.value);\n', '      \n', '  }\n', '  \n', '  function transferETHFromContract(address _to, uint256 _amount) private {\n', '\n', '    token_balance[0] = token_balance[0].sub(_amount);\n', '      \n', '    _to.transfer(_amount);\n', '      \n', '  }\n', '  \n', '  function deposit_token(uint256 _amount) private { \n', '\n', '    transferTokensThroughProxyToContract(msg.sender, this, _amount);\n', '\n', '  }  \n', '\n', '  function deposit_eth() private { \n', '\n', '    transferETHToContract();\n', '\n', '  }  \n', '  \n', '  function withdraw_token(uint256 _amount) public {\n', '\n', '      require(msg.sender == admin);\n', '      \n', '      uint256 currentBalance_ = token_balance[traded_token];\n', '      \n', '      require(currentBalance_ >= _amount);\n', '      \n', '      transferTokensFromContract(admin, _amount);\n', '      \n', '  }\n', '  \n', '  function withdraw_eth(uint256 _amount) public {\n', '      \n', '      require(msg.sender == admin);\n', '\n', '      uint256 currentBalance_ = token_balance[0];\n', '      \n', '      require(currentBalance_ >= _amount);\n', '      \n', '      transferETHFromContract(admin, _amount);\n', '      \n', '  }\n', '\n', '  function set_traded_token_as_seeded() private {\n', '   \n', '    traded_token_is_seeded = true;\n', ' \n', '  }\n', '\n', '  function set_base_token_as_seeded() private {\n', '\n', '    base_token_is_seeded = true;\n', '\n', '  }\n', '\n', '  function seed_traded_token() public {\n', '\n', '    require(!market_is_open());\n', '  \n', '    set_traded_token_as_seeded();\n', '\n', '    deposit_token(traded_token_seed_amount); \n', '\n', '  }\n', '  \n', '  function seed_base_token() public payable {\n', '\n', '    require(!market_is_open());\n', '\n', '    require(msg.value == base_token_seed_amount);\n', ' \n', '    set_base_token_as_seeded();\n', '\n', '    deposit_eth(); \n', '\n', '  }\n', '\n', '  function market_is_open() private view returns(bool) {\n', '  \n', '    return (base_token_is_seeded && traded_token_is_seeded);\n', '\n', '  }\n', '\n', '  function get_amount_sell(uint256 _amount) public view returns(uint256) {\n', ' \n', '    uint256 base_token_balance_ = token_balance[base_token]; \n', '\n', '    uint256 traded_token_balance_ = token_balance[traded_token];\n', '\n', '    uint256 traded_token_balance_plus_amount_ = traded_token_balance_ + _amount;\n', '    \n', '    return (2*base_token_balance_*_amount)/(traded_token_balance_ + traded_token_balance_plus_amount_);\n', '    \n', '  }\n', '\n', '  function get_amount_buy(uint256 _amount) public view returns(uint256) {\n', ' \n', '    uint256 base_token_balance_ = token_balance[base_token]; \n', '\n', '    uint256 traded_token_balance_ = token_balance[traded_token];\n', '\n', '    uint256 base_token_balance_plus_amount_ = base_token_balance_ + _amount;\n', '    \n', '    return (_amount*traded_token_balance_*(base_token_balance_plus_amount_ + base_token_balance_))/(2*base_token_balance_plus_amount_*base_token_balance_);\n', '   \n', '  }\n', '  \n', '  function get_amount_minus_fee(uint256 _amount) private view returns(uint256) {\n', '      \n', '    return (_amount*(1 ether - commission_ratio))/(1 ether);  \n', '    \n', '  }\n', '\n', '  function complete_sell_exchange(uint256 _amount_give) private {\n', '\n', '    uint256 amount_get_ = get_amount_sell(_amount_give);\n', '\n', '    require(amount_get_ < token_balance[base_token]);\n', '    \n', '    uint256 amount_get_minus_fee_ = get_amount_minus_fee(amount_get_);\n', '    \n', '    uint256 admin_fee = amount_get_ - amount_get_minus_fee_;\n', '\n', '    transferTokensThroughProxyToContract(msg.sender,this,_amount_give);\n', '\n', '    transferETHFromContract(msg.sender,amount_get_minus_fee_);  \n', '    \n', '    transferETHFromContract(admin, admin_fee);     \n', '      \n', '  }\n', '  \n', '  function complete_buy_exchange() private {\n', '\n', '    uint256 amount_give_ = msg.value;\n', '\n', '    uint256 amount_get_ = get_amount_buy(amount_give_);\n', '\n', '    require(amount_get_ < token_balance[traded_token]);\n', '    \n', '    uint256 amount_get_minus_fee_ = get_amount_minus_fee(amount_get_);\n', '\n', '    uint256 admin_fee = amount_get_ - amount_get_minus_fee_;\n', '    \n', '    transferETHToContract();\n', '\n', '    transferTokensFromContract(msg.sender, amount_get_minus_fee_);\n', '    \n', '    transferTokensFromContract(admin, admin_fee);\n', '    \n', '  }\n', '  \n', '  function sell_tokens(uint256 _amount_give) public {\n', '\n', '    require(market_is_open());\n', '\n', '    complete_sell_exchange(_amount_give);\n', '\n', '  }\n', '  \n', '  function buy_tokens() private {\n', '\n', '    require(market_is_open());\n', '\n', '    complete_buy_exchange();\n', '\n', '  }\n', '\n', '  function() public payable {\n', '\n', '    buy_tokens();\n', '\n', '  }\n', '\n', '}']