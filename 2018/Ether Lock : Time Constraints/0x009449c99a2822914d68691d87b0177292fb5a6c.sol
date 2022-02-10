['pragma solidity ^0.4.18;\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public admin;\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    admin = msg.sender;\n', '  }\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == admin);\n', '    _;\n', '  }\n', '}\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale.\n', ' * Crowdsales have a start and end timestamps, where investors can make\n', ' * token purchases and the crowdsale will assign them tokens based\n', ' * on a token per ETH rate. Funds collected are forwarded to a wallet\n', ' * as they arrive.\n', ' */\n', ' contract Crowdsale {\n', '  using SafeMath for uint256;\n', '  // start and end timestamps where investments are allowed (both inclusive)\n', '  uint256 public startTime;\n', '  uint256 public endTime;\n', '  // address where funds are collected\n', '  address public wallet;\n', '  // how many token units a buyer gets per wei\n', '  uint256 public rate;\n', '  // amount of raised money in wei\n', '  uint256 public weiRaised;\n', '  function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {\n', '    require(_startTime >= now);\n', '    require(_endTime >= _startTime);\n', '    require(_rate > 0);\n', '    require(_wallet != 0x0);\n', '    startTime = _startTime;\n', '    endTime = _endTime;\n', '    rate = _rate;\n', '    wallet = 0x00b95a5d838f02b12b75be562abf7ee0100410922b;\n', '  }\n', '  // @return true if the transaction can buy tokens\n', '  function validPurchase() internal constant returns (bool) {\n', '    bool withinPeriod = now >= startTime && now <= endTime;\n', '    bool nonZeroPurchase = msg.value != 0;\n', '    return withinPeriod && nonZeroPurchase;\n', '  }\n', '  // @return true if the transaction can mint tokens\n', '  function validMintPurchase(uint256 _value) internal constant returns (bool) {\n', '    bool withinPeriod = now >= startTime && now <= endTime;\n', '    bool nonZeroPurchase = _value != 0;\n', '    return withinPeriod && nonZeroPurchase;\n', '  }\n', '  // @return true if crowdsale event has ended\n', '  function hasEnded() public constant returns (bool) {\n', '    return now > endTime;\n', '  }\n', '}\n', '/**\n', ' * @title CappedCrowdsale\n', ' * @dev Extension of Crowdsale with a max amount of funds raised\n', ' */\n', ' contract CappedCrowdsale is Crowdsale {\n', '  using SafeMath for uint256;\n', '  uint256 public cap;\n', '  function CappedCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, uint256 _cap) public\n', '  Crowdsale(_startTime, _endTime, _rate, _wallet)\n', '  {\n', '    require(_cap > 0);\n', '    cap = _cap;\n', '  }\n', '  // overriding Crowdsale#validPurchase to add extra cap logic\n', '  // @return true if investors can buy at the moment\n', '  function validPurchase() internal constant returns (bool) {\n', '    bool withinCap = weiRaised.add(msg.value) <= cap;\n', '    return super.validPurchase() && withinCap;\n', '  }\n', '  // overriding Crowdsale#validPurchase to add extra cap logic\n', '  // @return true if investors can mint at the moment\n', '  function validMintPurchase(uint256 _value) internal constant returns (bool) {\n', '    bool withinCap = weiRaised.add(_value) <= cap;\n', '    return super.validMintPurchase(_value) && withinCap;\n', '  }\n', '  // overriding Crowdsale#hasEnded to add cap logic\n', '  // @return true if crowdsale event has ended\n', '  function hasEnded() public constant returns (bool) {\n', '    bool capReached = weiRaised >= cap;\n', '    return super.hasEnded() || capReached;\n', '  }\n', '}\n', 'contract HeartBoutToken {\n', '   function mint(address _to, uint256 _amount, string _account) public returns (bool);\n', '}\n', 'contract HeartBoutPreICO is CappedCrowdsale, Ownable {\n', '    using SafeMath for uint256;\n', '    \n', '    // The token address\n', '    address public token;\n', '    uint256 public minCount;\n', '    function HeartBoutPreICO(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, uint256 _cap, uint256 _minCount) public\n', '    CappedCrowdsale(_startTime, _endTime, _rate, _wallet, _cap)\n', '    {\n', '        token = 0x00f5b36df8732fb5a045bd90ab40082ab37897b841;\n', '        minCount = _minCount;\n', '    }\n', '    // fallback function can be used to buy tokens\n', '    function () payable public {}\n', '    // low level token purchase function\n', '    function buyTokens(string _account) public payable {\n', '        require(!stringEqual(_account, ""));\n', '        require(validPurchase());\n', '        require(msg.value >= minCount);\n', '        uint256 weiAmount = msg.value;\n', '        // calculate token amount to be created\n', '        uint256 tokens = weiAmount.mul(rate);\n', '        // Mint only message sender address\n', '        HeartBoutToken token_contract = HeartBoutToken(token);\n', '        token_contract.mint(msg.sender, tokens, _account);\n', '        // update state\n', '        weiRaised = weiRaised.add(weiAmount);\n', '        forwardFunds();\n', '    }\n', '    // mintTokens function\n', '    function mintTokens(address _to, uint256 _amount, string _account) onlyOwner public {\n', '        require(!stringEqual(_account, ""));\n', '        require(validMintPurchase(_amount));\n', '        require(_amount >= minCount);\n', '        uint256 weiAmount = _amount;\n', '        // calculate token amount to be created\n', '        uint256 tokens = weiAmount.mul(rate);\n', '        // Mint only message sender address\n', '        HeartBoutToken token_contract = HeartBoutToken(token);\n', '        token_contract.mint(_to, tokens, _account);\n', '        // update state\n', '        weiRaised = weiRaised.add(weiAmount);\n', '    }\n', '    // send ether to the fund collection wallet\n', '    // override to create custom fund forwarding mechanisms\n', '    function forwardFunds() internal {\n', '        wallet.transfer(msg.value);\n', '    }\n', '    function stringEqual(string _a, string _b) internal pure returns (bool) {\n', '        return keccak256(_a) == keccak256(_b);\n', '    }\n', '    // change wallet\n', '    function changeWallet(address _wallet) onlyOwner public {\n', '        wallet = _wallet;\n', '    }\n', '    // Remove contract\n', '    function removeContract() onlyOwner public {\n', '        selfdestruct(wallet);\n', '    }\n', '}']