['pragma solidity ^0.4.23;\n', '\n', 'library SafeMath {\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', 'contract Token {\n', ' \n', '  function transferFrom(address from, address to, uint256 tokens) public returns (bool success);\n', '\n', '  function transfer(address to, uint256 tokens) public returns (bool success);\n', '     \n', '}\n', '\n', 'contract TokenLiquidityContract { \n', '\n', '  using SafeMath for uint256;  \n', '\n', '\n', '  address public admin;\n', '\n', '  address public traded_token;\n', '\n', '  \n', '  uint256 public eth_seed_amount;\n', '\n', '  uint256 public traded_token_seed_amount;\n', '  \n', '  uint256 public commission_ratio;\n', '\n', '  uint256 public eth_balance;\n', '\n', '  uint256 public traded_token_balance;\n', '\n', '\n', '  bool public eth_is_seeded;\n', '\n', '  bool public traded_token_is_seeded;\n', '  \n', '  bool public trading_deactivated;\n', '\n', '  bool public admin_commission_activated;\n', '\n', '\n', '  modifier only_admin() {\n', '      require(msg.sender == admin);\n', '      _;\n', '  }\n', '  \n', '  modifier trading_activated() {\n', '      require(trading_deactivated == false);\n', '      _;\n', '  }\n', '\n', '  \n', '  constructor(address _traded_token,uint256 _eth_seed_amount, uint256 _traded_token_seed_amount, uint256 _commission_ratio) public {\n', '      \n', '    admin = tx.origin;  \n', '    \n', '    traded_token = _traded_token;\n', '    \n', '    eth_seed_amount = _eth_seed_amount;\n', '    \n', '    traded_token_seed_amount = _traded_token_seed_amount;\n', '\n', '    commission_ratio = _commission_ratio;\n', '    \n', '  }\n', '  \n', '  function transferTokensThroughProxyToContract(address _from, address _to, uint256 _amount) private {\n', '\n', '    traded_token_balance = traded_token_balance.add(_amount);\n', '\n', '    require(Token(traded_token).transferFrom(_from,_to,_amount));\n', '     \n', '  }  \n', '\n', '  function transferTokensFromContract(address _to, uint256 _amount) private {\n', '\n', '    traded_token_balance = traded_token_balance.sub(_amount);\n', '\n', '    require(Token(traded_token).transfer(_to,_amount));\n', '     \n', '  }\n', '\n', '  function transferETHToContract() private {\n', '\n', '    eth_balance = eth_balance.add(msg.value);\n', '      \n', '  }\n', '  \n', '  function transferETHFromContract(address _to, uint256 _amount) private {\n', '\n', '    eth_balance = eth_balance.sub(_amount);\n', '      \n', '    _to.transfer(_amount);\n', '      \n', '  }\n', '  \n', '  function deposit_token(uint256 _amount) private { \n', '\n', '    transferTokensThroughProxyToContract(msg.sender, this, _amount);\n', '\n', '  }  \n', '\n', '  function deposit_eth() private { \n', '\n', '    transferETHToContract();\n', '\n', '  }  \n', '  \n', '  function withdraw_token(uint256 _amount) public only_admin {\n', '\n', '    transferTokensFromContract(admin, _amount);\n', '      \n', '  }\n', '  \n', '  function withdraw_eth(uint256 _amount) public only_admin {\n', '      \n', '    transferETHFromContract(admin, _amount);\n', '      \n', '  }\n', '\n', '  function set_traded_token_as_seeded() private {\n', '   \n', '    traded_token_is_seeded = true;\n', ' \n', '  }\n', '\n', '  function set_eth_as_seeded() private {\n', '\n', '    eth_is_seeded = true;\n', '\n', '  }\n', '\n', '  function seed_traded_token() public only_admin {\n', '\n', '    require(!traded_token_is_seeded);\n', '  \n', '    set_traded_token_as_seeded();\n', '\n', '    deposit_token(traded_token_seed_amount); \n', '\n', '  }\n', '  \n', '  function seed_eth() public payable only_admin {\n', '\n', '    require(!eth_is_seeded);\n', '\n', '    require(msg.value == eth_seed_amount);\n', ' \n', '    set_eth_as_seeded();\n', '\n', '    deposit_eth(); \n', '\n', '  }\n', '\n', '  function seed_additional_token(uint256 _amount) public only_admin {\n', '\n', '    require(market_is_open());\n', '    \n', '    deposit_token(_amount);\n', '\n', '  }\n', '\n', '  function seed_additional_eth() public payable only_admin {\n', '  \n', '    require(market_is_open());\n', '    \n', '    deposit_eth();\n', '\n', '  }\n', '\n', '  function market_is_open() private view returns(bool) {\n', '  \n', '    return (eth_is_seeded && traded_token_is_seeded);\n', '\n', '  }\n', '\n', '  function deactivate_trading() public only_admin {\n', '  \n', '    require(!trading_deactivated);\n', '    \n', '    trading_deactivated = true;\n', '\n', '  }\n', '  \n', '  function reactivate_trading() public only_admin {\n', '      \n', '    require(trading_deactivated);\n', '    \n', '    trading_deactivated = false;\n', '    \n', '  }\n', '\n', '  function get_amount_sell(uint256 _amount) public view returns(uint256) {\n', ' \n', '    uint256 traded_token_balance_plus_amount_ = traded_token_balance.add(_amount);\n', '    \n', '    return (2*eth_balance*_amount)/(traded_token_balance + traded_token_balance_plus_amount_);\n', '    \n', '  }\n', '\n', '  function get_amount_buy(uint256 _amount) public view returns(uint256) {\n', '\n', '    uint256 eth_balance_plus_amount_ = eth_balance + _amount;\n', '    \n', '    return (_amount*traded_token_balance*(eth_balance_plus_amount_ + eth_balance))/(2*eth_balance_plus_amount_*eth_balance);\n', '   \n', '  }\n', '  \n', '  function get_amount_minus_commission(uint256 _amount) private view returns(uint256) {\n', '      \n', '    return (_amount*(1 ether - commission_ratio))/(1 ether);  \n', '    \n', '  }\n', '\n', '  function activate_admin_commission() public only_admin {\n', '\n', '    require(!admin_commission_activated);\n', '\n', '    admin_commission_activated = true;\n', '\n', '  }\n', '\n', '  function deactivate_admin_comission() public only_admin {\n', '\n', '    require(admin_commission_activated);\n', '\n', '    admin_commission_activated = false;\n', '\n', '  }\n', '\n', '  function change_admin_commission(uint256 _new_commission_ratio) public only_admin {\n', '  \n', '     require(_new_commission_ratio != commission_ratio);\n', '\n', '     commission_ratio = _new_commission_ratio;\n', '\n', '  }\n', '\n', '\n', '  function complete_sell_exchange(uint256 _amount_give) private {\n', '\n', '    uint256 amount_get_ = get_amount_sell(_amount_give);\n', '\n', '    uint256 amount_get_minus_commission_ = get_amount_minus_commission(amount_get_);\n', '    \n', '    transferTokensThroughProxyToContract(msg.sender,this,_amount_give);\n', '\n', '    transferETHFromContract(msg.sender,amount_get_minus_commission_);  \n', '\n', '    if(admin_commission_activated) {\n', '\n', '      uint256 admin_commission_ = amount_get_ - amount_get_minus_commission_;\n', '\n', '      transferETHFromContract(admin, admin_commission_);     \n', '\n', '    }\n', '    \n', '  }\n', '  \n', '  function complete_buy_exchange() private {\n', '\n', '    uint256 amount_give_ = msg.value;\n', '\n', '    uint256 amount_get_ = get_amount_buy(amount_give_);\n', '\n', '    uint256 amount_get_minus_commission_ = get_amount_minus_commission(amount_get_);\n', '\n', '    transferETHToContract();\n', '\n', '    transferTokensFromContract(msg.sender, amount_get_minus_commission_);\n', '\n', '    if(admin_commission_activated) {\n', '\n', '      uint256 admin_commission_ = amount_get_ - amount_get_minus_commission_;\n', '\n', '      transferTokensFromContract(admin, admin_commission_);\n', '\n', '    }\n', '    \n', '  }\n', '  \n', '  function sell_tokens(uint256 _amount_give) public trading_activated {\n', '\n', '    require(market_is_open());\n', '\n', '    complete_sell_exchange(_amount_give);\n', '\n', '  }\n', '  \n', '  function buy_tokens() private trading_activated {\n', '\n', '    require(market_is_open());\n', '\n', '    complete_buy_exchange();\n', '\n', '  }\n', '\n', '\n', '  function() public payable {\n', '\n', '    buy_tokens();\n', '\n', '  }\n', '\n', '}\n', '\n', 'contract TokenLiquidity { \n', '\n', '  function create_a_new_market(address _traded_token, uint256 _base_token_seed_amount, uint256 _traded_token_seed_amount, uint256 _commission_ratio) public {\n', '\n', '    new TokenLiquidityContract(_traded_token, _base_token_seed_amount, _traded_token_seed_amount, _commission_ratio);\n', '\n', '  }\n', '  \n', '  function() public payable {\n', '\n', '    revert();\n', '\n', '  }\n', '\n', '}']
['pragma solidity ^0.4.23;\n', '\n', 'library SafeMath {\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', 'contract Token {\n', ' \n', '  function transferFrom(address from, address to, uint256 tokens) public returns (bool success);\n', '\n', '  function transfer(address to, uint256 tokens) public returns (bool success);\n', '     \n', '}\n', '\n', 'contract TokenLiquidityContract { \n', '\n', '  using SafeMath for uint256;  \n', '\n', '\n', '  address public admin;\n', '\n', '  address public traded_token;\n', '\n', '  \n', '  uint256 public eth_seed_amount;\n', '\n', '  uint256 public traded_token_seed_amount;\n', '  \n', '  uint256 public commission_ratio;\n', '\n', '  uint256 public eth_balance;\n', '\n', '  uint256 public traded_token_balance;\n', '\n', '\n', '  bool public eth_is_seeded;\n', '\n', '  bool public traded_token_is_seeded;\n', '  \n', '  bool public trading_deactivated;\n', '\n', '  bool public admin_commission_activated;\n', '\n', '\n', '  modifier only_admin() {\n', '      require(msg.sender == admin);\n', '      _;\n', '  }\n', '  \n', '  modifier trading_activated() {\n', '      require(trading_deactivated == false);\n', '      _;\n', '  }\n', '\n', '  \n', '  constructor(address _traded_token,uint256 _eth_seed_amount, uint256 _traded_token_seed_amount, uint256 _commission_ratio) public {\n', '      \n', '    admin = tx.origin;  \n', '    \n', '    traded_token = _traded_token;\n', '    \n', '    eth_seed_amount = _eth_seed_amount;\n', '    \n', '    traded_token_seed_amount = _traded_token_seed_amount;\n', '\n', '    commission_ratio = _commission_ratio;\n', '    \n', '  }\n', '  \n', '  function transferTokensThroughProxyToContract(address _from, address _to, uint256 _amount) private {\n', '\n', '    traded_token_balance = traded_token_balance.add(_amount);\n', '\n', '    require(Token(traded_token).transferFrom(_from,_to,_amount));\n', '     \n', '  }  \n', '\n', '  function transferTokensFromContract(address _to, uint256 _amount) private {\n', '\n', '    traded_token_balance = traded_token_balance.sub(_amount);\n', '\n', '    require(Token(traded_token).transfer(_to,_amount));\n', '     \n', '  }\n', '\n', '  function transferETHToContract() private {\n', '\n', '    eth_balance = eth_balance.add(msg.value);\n', '      \n', '  }\n', '  \n', '  function transferETHFromContract(address _to, uint256 _amount) private {\n', '\n', '    eth_balance = eth_balance.sub(_amount);\n', '      \n', '    _to.transfer(_amount);\n', '      \n', '  }\n', '  \n', '  function deposit_token(uint256 _amount) private { \n', '\n', '    transferTokensThroughProxyToContract(msg.sender, this, _amount);\n', '\n', '  }  \n', '\n', '  function deposit_eth() private { \n', '\n', '    transferETHToContract();\n', '\n', '  }  \n', '  \n', '  function withdraw_token(uint256 _amount) public only_admin {\n', '\n', '    transferTokensFromContract(admin, _amount);\n', '      \n', '  }\n', '  \n', '  function withdraw_eth(uint256 _amount) public only_admin {\n', '      \n', '    transferETHFromContract(admin, _amount);\n', '      \n', '  }\n', '\n', '  function set_traded_token_as_seeded() private {\n', '   \n', '    traded_token_is_seeded = true;\n', ' \n', '  }\n', '\n', '  function set_eth_as_seeded() private {\n', '\n', '    eth_is_seeded = true;\n', '\n', '  }\n', '\n', '  function seed_traded_token() public only_admin {\n', '\n', '    require(!traded_token_is_seeded);\n', '  \n', '    set_traded_token_as_seeded();\n', '\n', '    deposit_token(traded_token_seed_amount); \n', '\n', '  }\n', '  \n', '  function seed_eth() public payable only_admin {\n', '\n', '    require(!eth_is_seeded);\n', '\n', '    require(msg.value == eth_seed_amount);\n', ' \n', '    set_eth_as_seeded();\n', '\n', '    deposit_eth(); \n', '\n', '  }\n', '\n', '  function seed_additional_token(uint256 _amount) public only_admin {\n', '\n', '    require(market_is_open());\n', '    \n', '    deposit_token(_amount);\n', '\n', '  }\n', '\n', '  function seed_additional_eth() public payable only_admin {\n', '  \n', '    require(market_is_open());\n', '    \n', '    deposit_eth();\n', '\n', '  }\n', '\n', '  function market_is_open() private view returns(bool) {\n', '  \n', '    return (eth_is_seeded && traded_token_is_seeded);\n', '\n', '  }\n', '\n', '  function deactivate_trading() public only_admin {\n', '  \n', '    require(!trading_deactivated);\n', '    \n', '    trading_deactivated = true;\n', '\n', '  }\n', '  \n', '  function reactivate_trading() public only_admin {\n', '      \n', '    require(trading_deactivated);\n', '    \n', '    trading_deactivated = false;\n', '    \n', '  }\n', '\n', '  function get_amount_sell(uint256 _amount) public view returns(uint256) {\n', ' \n', '    uint256 traded_token_balance_plus_amount_ = traded_token_balance.add(_amount);\n', '    \n', '    return (2*eth_balance*_amount)/(traded_token_balance + traded_token_balance_plus_amount_);\n', '    \n', '  }\n', '\n', '  function get_amount_buy(uint256 _amount) public view returns(uint256) {\n', '\n', '    uint256 eth_balance_plus_amount_ = eth_balance + _amount;\n', '    \n', '    return (_amount*traded_token_balance*(eth_balance_plus_amount_ + eth_balance))/(2*eth_balance_plus_amount_*eth_balance);\n', '   \n', '  }\n', '  \n', '  function get_amount_minus_commission(uint256 _amount) private view returns(uint256) {\n', '      \n', '    return (_amount*(1 ether - commission_ratio))/(1 ether);  \n', '    \n', '  }\n', '\n', '  function activate_admin_commission() public only_admin {\n', '\n', '    require(!admin_commission_activated);\n', '\n', '    admin_commission_activated = true;\n', '\n', '  }\n', '\n', '  function deactivate_admin_comission() public only_admin {\n', '\n', '    require(admin_commission_activated);\n', '\n', '    admin_commission_activated = false;\n', '\n', '  }\n', '\n', '  function change_admin_commission(uint256 _new_commission_ratio) public only_admin {\n', '  \n', '     require(_new_commission_ratio != commission_ratio);\n', '\n', '     commission_ratio = _new_commission_ratio;\n', '\n', '  }\n', '\n', '\n', '  function complete_sell_exchange(uint256 _amount_give) private {\n', '\n', '    uint256 amount_get_ = get_amount_sell(_amount_give);\n', '\n', '    uint256 amount_get_minus_commission_ = get_amount_minus_commission(amount_get_);\n', '    \n', '    transferTokensThroughProxyToContract(msg.sender,this,_amount_give);\n', '\n', '    transferETHFromContract(msg.sender,amount_get_minus_commission_);  \n', '\n', '    if(admin_commission_activated) {\n', '\n', '      uint256 admin_commission_ = amount_get_ - amount_get_minus_commission_;\n', '\n', '      transferETHFromContract(admin, admin_commission_);     \n', '\n', '    }\n', '    \n', '  }\n', '  \n', '  function complete_buy_exchange() private {\n', '\n', '    uint256 amount_give_ = msg.value;\n', '\n', '    uint256 amount_get_ = get_amount_buy(amount_give_);\n', '\n', '    uint256 amount_get_minus_commission_ = get_amount_minus_commission(amount_get_);\n', '\n', '    transferETHToContract();\n', '\n', '    transferTokensFromContract(msg.sender, amount_get_minus_commission_);\n', '\n', '    if(admin_commission_activated) {\n', '\n', '      uint256 admin_commission_ = amount_get_ - amount_get_minus_commission_;\n', '\n', '      transferTokensFromContract(admin, admin_commission_);\n', '\n', '    }\n', '    \n', '  }\n', '  \n', '  function sell_tokens(uint256 _amount_give) public trading_activated {\n', '\n', '    require(market_is_open());\n', '\n', '    complete_sell_exchange(_amount_give);\n', '\n', '  }\n', '  \n', '  function buy_tokens() private trading_activated {\n', '\n', '    require(market_is_open());\n', '\n', '    complete_buy_exchange();\n', '\n', '  }\n', '\n', '\n', '  function() public payable {\n', '\n', '    buy_tokens();\n', '\n', '  }\n', '\n', '}\n', '\n', 'contract TokenLiquidity { \n', '\n', '  function create_a_new_market(address _traded_token, uint256 _base_token_seed_amount, uint256 _traded_token_seed_amount, uint256 _commission_ratio) public {\n', '\n', '    new TokenLiquidityContract(_traded_token, _base_token_seed_amount, _traded_token_seed_amount, _commission_ratio);\n', '\n', '  }\n', '  \n', '  function() public payable {\n', '\n', '    revert();\n', '\n', '  }\n', '\n', '}']
