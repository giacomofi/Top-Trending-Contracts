['pragma solidity ^0.4.23;\n', '\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a / b;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', 'contract Token {\n', ' \n', '  function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '  function transfer(address to, uint tokens) public returns (bool success);\n', '     \n', '}\n', '\n', 'contract BancorKillerContract { \n', '\n', '  using SafeMath for uint256;\n', '\n', '  address public admin;\n', '\n', '  address public base_token;\n', '\n', '  address public traded_token;\n', '  \n', '  uint public base_token_seed_amount;\n', '\n', '  uint public traded_token_seed_amount;\n', '  \n', '  uint public commission_ratio;\n', '\n', '  bool public base_token_is_seeded;\n', '\n', '  bool public traded_token_is_seeded;\n', '\n', '  mapping (address => uint) public token_balance;\n', '  \n', '  modifier onlyAdmin() {\n', '      msg.sender == admin;\n', '      _;\n', '  }\n', '\n', '  constructor(address _base_token, address _traded_token,uint _base_token_seed_amount, uint _traded_token_seed_amount, uint _commission_ratio) public {\n', '      \n', '    admin = tx.origin;  \n', '      \n', '    base_token = _base_token;\n', '    \n', '    traded_token = _traded_token;\n', '    \n', '    base_token_seed_amount = _base_token_seed_amount;\n', '    \n', '    traded_token_seed_amount = _traded_token_seed_amount;\n', '\n', '    commission_ratio = _commission_ratio;\n', '    \n', '  }\n', '\n', '  function transferTokensThroughProxy(address _from, address _to, uint256 _amount) private {\n', '\n', '    require(Token(traded_token).transferFrom(_from,_to,_amount));\n', '     \n', '  }\n', '  \n', '    function transferTokens(address _to, uint256 _amount) private {\n', '\n', '    require(Token(traded_token).transfer(_to,_amount));\n', '     \n', '  }\n', '\n', '  function transferETH(address _to, uint256 _amount) private {\n', '      \n', '    _to.transfer(_amount);\n', '      \n', '  }\n', '  \n', '  function deposit_token(address _token, uint _amount) private { \n', '\n', '    token_balance[_token] = token_balance[_token].add(_amount);\n', '\n', '    transferTokensThroughProxy(msg.sender, this, _amount);\n', '\n', '  }  \n', '\n', '  function deposit_eth() private { \n', '\n', '    token_balance[0] = token_balance[0].add(msg.value);\n', '\n', '  }  \n', '  \n', '  function withdraw_token(uint _amount) onlyAdmin public {\n', '      \n', '      uint currentBalance_ = token_balance[traded_token];\n', '      \n', '      require(currentBalance_ >= _amount);\n', '      \n', '      transferTokens(msg.sender, _amount);\n', '      \n', '  }\n', '  \n', '  function withdraw_eth(uint _amount) onlyAdmin public {\n', '      \n', '      uint currentBalance_ = token_balance[0];\n', '      \n', '      require(currentBalance_ >= _amount);\n', '      \n', '      transferETH(msg.sender, _amount);\n', '      \n', '  }\n', '\n', '  function set_traded_token_as_seeded() private {\n', '   \n', '    traded_token_is_seeded = true;\n', ' \n', '  }\n', '\n', '  function set_base_token_as_seeded() private {\n', '\n', '    base_token_is_seeded = true;\n', '\n', '  }\n', '\n', '  function seed_traded_token() public {\n', '\n', '    require(!market_is_open());\n', '  \n', '    set_traded_token_as_seeded();\n', '\n', '    deposit_token(traded_token, traded_token_seed_amount); \n', '\n', '  }\n', '  \n', '  function seed_base_token() public payable {\n', '\n', '    require(!market_is_open());\n', '\n', '    set_base_token_as_seeded();\n', '\n', '    deposit_eth(); \n', '\n', '  }\n', '\n', '  function market_is_open() private view returns(bool) {\n', '  \n', '    return (base_token_is_seeded && traded_token_is_seeded);\n', '\n', '  }\n', '\n', '  function calculate_price(uint _pre_pay_in_price,uint _post_pay_in_price) private pure returns(uint256) {\n', '\n', '    return (_pre_pay_in_price.add(_post_pay_in_price)).div(2);\n', '\n', '  }\n', '\n', '  function get_amount_get_sell(uint256 _amount) private view returns(uint256) {\n', '   \n', '    uint traded_token_balance_ = token_balance[traded_token];\n', '    \n', '    uint base_token_balance_ = token_balance[base_token];    \n', '\n', '    uint pre_pay_in_price_ = traded_token_balance_.div(base_token_balance_);\n', '\n', '    uint post_pay_in_price_ = (traded_token_balance_.add(_amount)).div(base_token_balance_);\n', '   \n', '    uint adjusted_price_ = calculate_price(pre_pay_in_price_,post_pay_in_price_);\n', '\n', '    return _amount.div(adjusted_price_);   \n', '      \n', '  }\n', '\n', '  function get_amount_get_buy(uint256 _amount) private view returns(uint256) {\n', ' \n', '    uint traded_token_balance_ = token_balance[traded_token];\n', '    \n', '    uint base_token_balance_ = token_balance[base_token];    \n', '\n', '    uint pre_pay_in_price_ = traded_token_balance_.div(base_token_balance_);\n', '\n', '    uint post_pay_in_price_ = traded_token_balance_.div(base_token_balance_.add(_amount));\n', '   \n', '    uint adjusted_price_ = calculate_price(pre_pay_in_price_,post_pay_in_price_);\n', '\n', '    return _amount.mul(adjusted_price_);\n', '    \n', '  }\n', '\n', '  function complete_sell_exchange(uint _amount_give) private {\n', '\n', '    uint amount_get_ = get_amount_get_sell(_amount_give);\n', '    \n', '    uint amount_get_minus_fee_ = (amount_get_.mul(1 ether - commission_ratio)).div(1 ether);\n', '    \n', '    uint admin_fee = amount_get_ - amount_get_minus_fee_;\n', '\n', '    transferTokensThroughProxy(msg.sender,this,_amount_give);\n', '\n', '    transferETH(msg.sender,amount_get_minus_fee_);  \n', '    \n', '    transferETH(admin, admin_fee);      \n', '      \n', '  }\n', '  \n', '  function complete_buy_exchange() private {\n', '    \n', '    uint amount_give_ = msg.value;\n', '\n', '    uint amount_get_ = get_amount_get_buy(amount_give_);\n', '    \n', '    uint amount_get_minus_fee_ = (amount_get_.mul(1 ether - commission_ratio)).div(1 ether);\n', '\n', '    uint admin_fee = amount_get_ - amount_get_minus_fee_;\n', '\n', '    transferTokens(msg.sender, amount_get_minus_fee_);\n', '    \n', '    transferETH(admin, admin_fee);\n', '    \n', '  }\n', '  \n', '  function sell_tokens(uint _amount_give) public {\n', '\n', '    require(market_is_open());\n', '\n', '    complete_sell_exchange(_amount_give);\n', '\n', '  }\n', '  \n', '  function buy_tokens() private {\n', '\n', '    require(market_is_open());\n', '\n', '    complete_buy_exchange();\n', '\n', '  }\n', '\n', '  function() public payable {\n', '\n', '    buy_tokens();\n', '\n', '  }\n', '\n', '}\n', '\n', 'contract BancorKiller { \n', '\n', '  function create_a_new_market(address _base_token, address _traded_token, uint _base_token_seed_amount, uint _traded_token_seed_amount, uint _commission_ratio) public {\n', '\n', '    new BancorKillerContract(_base_token, _traded_token, _base_token_seed_amount, _traded_token_seed_amount, _commission_ratio);\n', '\n', '  }\n', '  \n', '  function() public payable {\n', '\n', '    revert();\n', '\n', '  }\n', '\n', '}']