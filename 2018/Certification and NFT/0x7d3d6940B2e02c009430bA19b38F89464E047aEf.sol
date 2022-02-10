['pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract Whitelist is Ownable {\n', '    mapping(address => bool) whitelist;\n', '    event AddedToWhitelist(address indexed account);\n', '    event RemovedFromWhitelist(address indexed account);\n', '\n', '    modifier onlyWhitelisted() {\n', '        require(isWhitelisted(msg.sender));\n', '        _;\n', '    }\n', '\n', '    function add(address _address) public onlyOwner {\n', '        whitelist[_address] = true;\n', '        emit AddedToWhitelist(_address);\n', '    }\n', '\n', '    function remove(address _address) public onlyOwner {\n', '        whitelist[_address] = false;\n', '        emit RemovedFromWhitelist(_address);\n', '    }\n', '\n', '    function isWhitelisted(address _address) public view returns(bool) {\n', '        return whitelist[_address];\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', 'contract MintableToken is StandardToken, Ownable {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '    totalSupply_ = totalSupply_.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    Transfer(address(0), _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner canMint public returns (bool) {\n', '    mintingFinished = true;\n', '    MintFinished();\n', '    return true;\n', '  }\n', '}\n', '\n', '\n', 'contract CrowdfundableToken is MintableToken {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public cap;\n', '\n', '    function CrowdfundableToken(uint256 _cap, string _name, string _symbol, uint8 _decimals) public {\n', '        require(_cap > 0);\n', '        require(bytes(_name).length > 0);\n', '        require(bytes(_symbol).length > 0);\n', '        cap = _cap;\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '    }\n', '\n', '    // override\n', '    function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '        require(totalSupply_.add(_amount) <= cap);\n', '        return super.mint(_to, _amount);\n', '    }\n', '\n', '    // override\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(mintingFinished == true);\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    // override\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(mintingFinished == true);\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function burn(uint amount) public {\n', '        totalSupply_ = totalSupply_.sub(amount);\n', '        balances[msg.sender] = balances[msg.sender].sub(amount);\n', '    }\n', '}\n', '\n', 'contract Minter is Ownable {\n', '    using SafeMath for uint;\n', '\n', '    /* --- EVENTS --- */\n', '\n', '    event Minted(address indexed account, uint etherAmount, uint tokenAmount);\n', '    event Reserved(uint etherAmount);\n', '    event MintedReserved(address indexed account, uint etherAmount, uint tokenAmount);\n', '    event Unreserved(uint etherAmount);\n', '\n', '    /* --- FIELDS --- */\n', '\n', '    CrowdfundableToken public token;\n', '    uint public saleEtherCap;\n', '    uint public confirmedSaleEther;\n', '    uint public reservedSaleEther;\n', '\n', '    /* --- MODIFIERS --- */\n', '\n', '    modifier onlyInUpdatedState() {\n', '        updateState();\n', '        _;\n', '    }\n', '\n', '    modifier upToSaleEtherCap(uint additionalEtherAmount) {\n', '        uint totalEtherAmount = confirmedSaleEther.add(reservedSaleEther).add(additionalEtherAmount);\n', '        require(totalEtherAmount <= saleEtherCap);\n', '        _;\n', '    }\n', '\n', '    modifier onlyApprovedMinter() {\n', '        require(canMint(msg.sender));\n', '        _;\n', '    }\n', '\n', '    modifier atLeastMinimumAmount(uint etherAmount) {\n', '        require(etherAmount >= getMinimumContribution());\n', '        _;\n', '    }\n', '\n', '    modifier onlyValidAddress(address account) {\n', '        require(account != 0x0);\n', '        _;\n', '    }\n', '\n', '    /* --- CONSTRUCTOR --- */\n', '\n', '    constructor(CrowdfundableToken _token, uint _saleEtherCap) public onlyValidAddress(address(_token)) {\n', '        require(_saleEtherCap > 0);\n', '\n', '        token = _token;\n', '        saleEtherCap = _saleEtherCap;\n', '    }\n', '\n', '    /* --- PUBLIC / EXTERNAL METHODS --- */\n', '\n', '    function transferTokenOwnership() external onlyOwner {\n', '        token.transferOwnership(owner);\n', '    }\n', '\n', '    function reserve(uint etherAmount) external\n', '        onlyInUpdatedState\n', '        onlyApprovedMinter\n', '        upToSaleEtherCap(etherAmount)\n', '        atLeastMinimumAmount(etherAmount)\n', '    {\n', '        reservedSaleEther = reservedSaleEther.add(etherAmount);\n', '        updateState();\n', '        emit Reserved(etherAmount);\n', '    }\n', '\n', '    function mintReserved(address account, uint etherAmount, uint tokenAmount) external\n', '        onlyInUpdatedState\n', '        onlyApprovedMinter\n', '    {\n', '        reservedSaleEther = reservedSaleEther.sub(etherAmount);\n', '        confirmedSaleEther = confirmedSaleEther.add(etherAmount);\n', '        require(token.mint(account, tokenAmount));\n', '        updateState();\n', '        emit MintedReserved(account, etherAmount, tokenAmount);\n', '    }\n', '\n', '    function unreserve(uint etherAmount) public\n', '        onlyInUpdatedState\n', '        onlyApprovedMinter\n', '    {\n', '        reservedSaleEther = reservedSaleEther.sub(etherAmount);\n', '        updateState();\n', '        emit Unreserved(etherAmount);\n', '    }\n', '\n', '    function mint(address account, uint etherAmount, uint tokenAmount) public\n', '        onlyInUpdatedState\n', '        onlyApprovedMinter\n', '        upToSaleEtherCap(etherAmount)\n', '    {\n', '        confirmedSaleEther = confirmedSaleEther.add(etherAmount);\n', '        require(token.mint(account, tokenAmount));\n', '        updateState();\n', '        emit Minted(account, etherAmount, tokenAmount);\n', '    }\n', '\n', '    // abstract\n', '    function getMinimumContribution() public view returns(uint);\n', '\n', '    // abstract\n', '    function updateState() public;\n', '\n', '    // abstract\n', '    function canMint(address sender) public view returns(bool);\n', '\n', '    // abstract\n', '    function getTokensForEther(uint etherAmount) public view returns(uint);\n', '}\n', '\n', 'contract ExternalMinter {\n', '    Minter public minter;\n', '}\n', '\n', 'contract Tge is Minter {\n', '    using SafeMath for uint;\n', '\n', '    /* --- CONSTANTS --- */\n', '\n', '    uint constant public MIMIMUM_CONTRIBUTION_AMOUNT_PREICO = 3 ether;\n', '    uint constant public MIMIMUM_CONTRIBUTION_AMOUNT_ICO = 1 ether / 5;\n', '    \n', '    uint constant public PRICE_MULTIPLIER_PREICO1 = 1443000;\n', '    uint constant public PRICE_MULTIPLIER_PREICO2 = 1415000;\n', '\n', '    uint constant public PRICE_MULTIPLIER_ICO1 = 1332000;\n', '    uint constant public PRICE_MULTIPLIER_ICO2 = 1304000;\n', '    uint constant public PRICE_MULTIPLIER_ICO3 = 1248000;\n', '    uint constant public PRICE_MULTIPLIER_ICO4 = 1221000;\n', '    uint constant public PRICE_MULTIPLIER_ICO5 = 1165000;\n', '    uint constant public PRICE_MULTIPLIER_ICO6 = 1110000;\n', '    uint constant public PRICE_DIVIDER = 1000;\n', '\n', '    /* --- EVENTS --- */\n', '\n', '    event StateChanged(uint from, uint to);\n', '    event PrivateIcoInitialized(uint _cap, uint _tokensForEther, uint _startTime, uint _endTime, uint _minimumContribution);\n', '    event PrivateIcoFinalized();\n', '\n', '    /* --- FIELDS --- */\n', '\n', '    // minters\n', '    address public crowdsale;\n', '    address public deferredKyc;\n', '    address public referralManager;\n', '    address public allocator;\n', '    address public airdropper;\n', '\n', '    // state\n', '    enum State {Presale, Preico1, Preico2, Break, Ico1, Ico2, Ico3, Ico4, Ico5, Ico6, FinishingIco, Allocating, Airdropping, Finished}\n', '    State public currentState = State.Presale;\n', '    mapping(uint => uint) public startTimes;\n', '    mapping(uint => uint) public etherCaps;\n', '\n', '    // private ico\n', '    bool public privateIcoFinalized = true;\n', '    uint public privateIcoCap = 0;\n', '    uint public privateIcoTokensForEther = 0;\n', '    uint public privateIcoStartTime = 0;\n', '    uint public privateIcoEndTime = 0;\n', '    uint public privateIcoMinimumContribution = 0;\n', '\n', '    /* --- MODIFIERS --- */\n', '\n', '    modifier onlyInState(State _state) {\n', '        require(_state == currentState);\n', '        _;\n', '    }\n', '\n', '    modifier onlyProperExternalMinters(address minter1, address minter2, address minter3, address minter4, address minter5) {\n', '        require(ExternalMinter(minter1).minter() == address(this));\n', '        require(ExternalMinter(minter2).minter() == address(this));\n', '        require(ExternalMinter(minter3).minter() == address(this));\n', '        require(ExternalMinter(minter4).minter() == address(this));\n', '        require(ExternalMinter(minter5).minter() == address(this));\n', '        _;\n', '    }\n', '\n', '    /* --- CONSTRUCTOR / INITIALIZATION --- */\n', '\n', '    constructor(\n', '        CrowdfundableToken _token,\n', '        uint _saleEtherCap\n', '    ) public Minter(_token, _saleEtherCap) {\n', '        require(keccak256(_token.symbol()) == keccak256("ALL"));\n', '        require(_token.totalSupply() == 0);\n', '    }\n', '\n', '    // initialize states start times and caps\n', '    function setupStates(uint saleStart, uint singleStateEtherCap, uint[] stateLengths) internal {\n', '        require(!isPrivateIcoActive());\n', '\n', '        startTimes[uint(State.Preico1)] = saleStart;\n', '        setStateLength(State.Preico1, stateLengths[0]);\n', '        setStateLength(State.Preico2, stateLengths[1]);\n', '        setStateLength(State.Break, stateLengths[2]);\n', '        setStateLength(State.Ico1, stateLengths[3]);\n', '        setStateLength(State.Ico2, stateLengths[4]);\n', '        setStateLength(State.Ico3, stateLengths[5]);\n', '        setStateLength(State.Ico4, stateLengths[6]);\n', '        setStateLength(State.Ico5, stateLengths[7]);\n', '        setStateLength(State.Ico6, stateLengths[8]);\n', '\n', '        // the total sale ether cap is distributed evenly over all selling states\n', '        // the cap from previous states is accumulated in consequent states\n', '        // adding confirmed sale ether from private ico\n', '        etherCaps[uint(State.Preico1)] = singleStateEtherCap;\n', '        etherCaps[uint(State.Preico2)] = singleStateEtherCap.mul(2);\n', '        etherCaps[uint(State.Ico1)] = singleStateEtherCap.mul(3);\n', '        etherCaps[uint(State.Ico2)] = singleStateEtherCap.mul(4);\n', '        etherCaps[uint(State.Ico3)] = singleStateEtherCap.mul(5);\n', '        etherCaps[uint(State.Ico4)] = singleStateEtherCap.mul(6);\n', '        etherCaps[uint(State.Ico5)] = singleStateEtherCap.mul(7);\n', '        etherCaps[uint(State.Ico6)] = singleStateEtherCap.mul(8);\n', '    }\n', '\n', '    function setup(\n', '        address _crowdsale,\n', '        address _deferredKyc,\n', '        address _referralManager,\n', '        address _allocator,\n', '        address _airdropper,\n', '        uint saleStartTime,\n', '        uint singleStateEtherCap,\n', '        uint[] stateLengths\n', '    )\n', '    public\n', '    onlyOwner\n', '    onlyInState(State.Presale)\n', '    onlyProperExternalMinters(_crowdsale, _deferredKyc, _referralManager, _allocator, _airdropper)\n', '    {\n', '        require(stateLengths.length == 9); // preico 1-2, break, ico 1-6\n', '        require(saleStartTime >= now);\n', '        require(singleStateEtherCap > 0);\n', '        require(singleStateEtherCap.mul(8) <= saleEtherCap);\n', '        crowdsale = _crowdsale;\n', '        deferredKyc = _deferredKyc;\n', '        referralManager = _referralManager;\n', '        allocator = _allocator;\n', '        airdropper = _airdropper;\n', '        setupStates(saleStartTime, singleStateEtherCap, stateLengths);\n', '    }\n', '\n', '    /* --- PUBLIC / EXTERNAL METHODS --- */\n', '\n', '    function moveState(uint from, uint to) external onlyInUpdatedState onlyOwner {\n', '        require(uint(currentState) == from);\n', '        advanceStateIfNewer(State(to));\n', '    }\n', '\n', '    // override\n', '    function transferTokenOwnership() external onlyInUpdatedState onlyOwner {\n', '        require(currentState == State.Finished);\n', '        token.transferOwnership(owner);\n', '    }\n', '\n', '    // override\n', '    function getTokensForEther(uint etherAmount) public view returns(uint) {\n', '        uint tokenAmount = 0;\n', '        if (isPrivateIcoActive()) tokenAmount = etherAmount.mul(privateIcoTokensForEther).div(PRICE_DIVIDER);\n', '        else if (currentState == State.Preico1) tokenAmount = etherAmount.mul(PRICE_MULTIPLIER_PREICO1).div(PRICE_DIVIDER);\n', '        else if (currentState == State.Preico2) tokenAmount = etherAmount.mul(PRICE_MULTIPLIER_PREICO2).div(PRICE_DIVIDER);\n', '        else if (currentState == State.Ico1) tokenAmount = etherAmount.mul(PRICE_MULTIPLIER_ICO1).div(PRICE_DIVIDER);\n', '        else if (currentState == State.Ico2) tokenAmount = etherAmount.mul(PRICE_MULTIPLIER_ICO2).div(PRICE_DIVIDER);\n', '        else if (currentState == State.Ico3) tokenAmount = etherAmount.mul(PRICE_MULTIPLIER_ICO3).div(PRICE_DIVIDER);\n', '        else if (currentState == State.Ico4) tokenAmount = etherAmount.mul(PRICE_MULTIPLIER_ICO4).div(PRICE_DIVIDER);\n', '        else if (currentState == State.Ico5) tokenAmount = etherAmount.mul(PRICE_MULTIPLIER_ICO5).div(PRICE_DIVIDER);\n', '        else if (currentState == State.Ico6) tokenAmount = etherAmount.mul(PRICE_MULTIPLIER_ICO6).div(PRICE_DIVIDER);\n', '\n', '        return tokenAmount;\n', '    }\n', '\n', '    function isSellingState() public view returns(bool) {\n', '        if (currentState == State.Presale) return isPrivateIcoActive();\n', '        return (\n', '            uint(currentState) >= uint(State.Preico1) &&\n', '            uint(currentState) <= uint(State.Ico6) &&\n', '            uint(currentState) != uint(State.Break)\n', '        );\n', '    }\n', '\n', '    function isPrivateIcoActive() public view returns(bool) {\n', '        return now >= privateIcoStartTime && now < privateIcoEndTime;\n', '    }\n', '\n', '    function initPrivateIco(uint _cap, uint _tokensForEther, uint _startTime, uint _endTime, uint _minimumContribution) external onlyOwner {\n', '        require(_startTime > privateIcoEndTime); // should start after previous private ico\n', '        require(now >= privateIcoEndTime); // previous private ico should be finished\n', '        require(privateIcoFinalized); // previous private ico should be finalized\n', '        require(_tokensForEther > 0);\n', '        require(_endTime > _startTime);\n', '        require(_endTime < startTimes[uint(State.Preico1)]);\n', '\n', '        privateIcoCap = _cap;\n', '        privateIcoTokensForEther = _tokensForEther;\n', '        privateIcoStartTime = _startTime;\n', '        privateIcoEndTime = _endTime;\n', '        privateIcoMinimumContribution = _minimumContribution;\n', '        privateIcoFinalized = false;\n', '        emit PrivateIcoInitialized(_cap, _tokensForEther, _startTime, _endTime, _minimumContribution);\n', '    }\n', '\n', '    function finalizePrivateIco() external onlyOwner {\n', '        require(!isPrivateIcoActive());\n', '        require(now >= privateIcoEndTime); // previous private ico should be finished\n', '        require(!privateIcoFinalized);\n', '        require(reservedSaleEther == 0); // kyc needs to be finished\n', '\n', '        privateIcoFinalized = true;\n', '        confirmedSaleEther = 0;\n', '        emit PrivateIcoFinalized();\n', '    }\n', '\n', '    /* --- INTERNAL METHODS --- */\n', '\n', '    // override\n', '    function getMinimumContribution() public view returns(uint) {\n', '        if (currentState == State.Preico1 || currentState == State.Preico2) {\n', '            return MIMIMUM_CONTRIBUTION_AMOUNT_PREICO;\n', '        }\n', '        if (uint(currentState) >= uint(State.Ico1) && uint(currentState) <= uint(State.Ico6)) {\n', '            return MIMIMUM_CONTRIBUTION_AMOUNT_ICO;\n', '        }\n', '        if (isPrivateIcoActive()) {\n', '            return privateIcoMinimumContribution;\n', '        }\n', '        return 0;\n', '    }\n', '\n', '    // override\n', '    function canMint(address account) public view returns(bool) {\n', '        if (currentState == State.Presale) {\n', '            // external sales and private ico\n', '            return account == crowdsale || account == deferredKyc;\n', '        }\n', '        else if (isSellingState()) {\n', '            // crowdsale: external sales\n', '            // deferredKyc: adding and approving kyc\n', '            // referralManager: referral fees\n', '            return account == crowdsale || account == deferredKyc || account == referralManager;\n', '        }\n', '        else if (currentState == State.Break || currentState == State.FinishingIco) {\n', '            // crowdsale: external sales\n', '            // deferredKyc: approving kyc\n', '            // referralManager: referral fees\n', '            return account == crowdsale || account == deferredKyc || account == referralManager;\n', '        }\n', '        else if (currentState == State.Allocating) {\n', '            // Community and Bounty allocations\n', '            // Advisors, Developers, Ambassadors and Partners allocations\n', '            // Customer Rewards allocations\n', '            // Team allocations\n', '            return account == allocator;\n', '        }\n', '        else if (currentState == State.Airdropping) {\n', '            // airdropping for all token holders\n', '            return account == airdropper;\n', '        }\n', '        return false;\n', '    }\n', '\n', '    // override\n', '    function updateState() public {\n', '        updateStateBasedOnTime();\n', '        updateStateBasedOnContributions();\n', '    }\n', '\n', '    function updateStateBasedOnTime() internal {\n', '        // move to the next state, if the current one has finished\n', '        if (now >= startTimes[uint(State.FinishingIco)]) advanceStateIfNewer(State.FinishingIco);\n', '        else if (now >= startTimes[uint(State.Ico6)]) advanceStateIfNewer(State.Ico6);\n', '        else if (now >= startTimes[uint(State.Ico5)]) advanceStateIfNewer(State.Ico5);\n', '        else if (now >= startTimes[uint(State.Ico4)]) advanceStateIfNewer(State.Ico4);\n', '        else if (now >= startTimes[uint(State.Ico3)]) advanceStateIfNewer(State.Ico3);\n', '        else if (now >= startTimes[uint(State.Ico2)]) advanceStateIfNewer(State.Ico2);\n', '        else if (now >= startTimes[uint(State.Ico1)]) advanceStateIfNewer(State.Ico1);\n', '        else if (now >= startTimes[uint(State.Break)]) advanceStateIfNewer(State.Break);\n', '        else if (now >= startTimes[uint(State.Preico2)]) advanceStateIfNewer(State.Preico2);\n', '        else if (now >= startTimes[uint(State.Preico1)]) advanceStateIfNewer(State.Preico1);\n', '    }\n', '\n', '    function updateStateBasedOnContributions() internal {\n', '        // move to the next state, if the current one&#39;s cap has been reached\n', '        uint totalEtherContributions = confirmedSaleEther.add(reservedSaleEther);\n', '        if(isPrivateIcoActive()) {\n', '            // if private ico cap exceeded, revert transaction\n', '            require(totalEtherContributions <= privateIcoCap);\n', '            return;\n', '        }\n', '        \n', '        if (!isSellingState()) {\n', '            return;\n', '        }\n', '        \n', '        else if (int(currentState) < int(State.Break)) {\n', '            // preico\n', '            if (totalEtherContributions >= etherCaps[uint(State.Preico2)]) advanceStateIfNewer(State.Break);\n', '            else if (totalEtherContributions >= etherCaps[uint(State.Preico1)]) advanceStateIfNewer(State.Preico2);\n', '        }\n', '        else {\n', '            // ico\n', '            if (totalEtherContributions >= etherCaps[uint(State.Ico6)]) advanceStateIfNewer(State.FinishingIco);\n', '            else if (totalEtherContributions >= etherCaps[uint(State.Ico5)]) advanceStateIfNewer(State.Ico6);\n', '            else if (totalEtherContributions >= etherCaps[uint(State.Ico4)]) advanceStateIfNewer(State.Ico5);\n', '            else if (totalEtherContributions >= etherCaps[uint(State.Ico3)]) advanceStateIfNewer(State.Ico4);\n', '            else if (totalEtherContributions >= etherCaps[uint(State.Ico2)]) advanceStateIfNewer(State.Ico3);\n', '            else if (totalEtherContributions >= etherCaps[uint(State.Ico1)]) advanceStateIfNewer(State.Ico2);\n', '        }\n', '    }\n', '\n', '    function advanceStateIfNewer(State newState) internal {\n', '        if (uint(newState) > uint(currentState)) {\n', '            emit StateChanged(uint(currentState), uint(newState));\n', '            currentState = newState;\n', '        }\n', '    }\n', '\n', '    function setStateLength(State state, uint length) internal {\n', '        // state length is determined by next state&#39;s start time\n', '        startTimes[uint(state)+1] = startTimes[uint(state)].add(length);\n', '    }\n', '\n', '    function isInitialized() public view returns(bool) {\n', '        return crowdsale != 0x0 && referralManager != 0x0 && allocator != 0x0 && airdropper != 0x0 && deferredKyc != 0x0;\n', '    }\n', '}\n', '\n', '\n', 'contract Airdropper is Ownable {\n', '    using SafeMath for uint;\n', '\n', '    /* --- CONSTANTS --- */\n', '\n', '    uint constant public ETHER_AMOUNT = 0;\n', '    uint constant public MAXIMUM_LOOP_BOUND = 15;\n', '\n', '    /* --- EVENTS --- */\n', '\n', '    event Initialized();\n', '    event Airdropped(address indexed account, uint tokenAmount);\n', '\n', '    /* --- FIELDS --- */\n', '\n', '    Minter public minter;\n', '    bool public isInitialized = false;\n', '    uint public initialTotalSupply;\n', '    uint public airdropPool;\n', '    mapping(address => bool) public dropped;\n', '\n', '    /* --- MODIFIERS --- */\n', '\n', '    modifier notAlreadyDropped(address account) {\n', '        require(!dropped[account]);\n', '        _;\n', '    }\n', '\n', '    modifier initialized {\n', '        if (!isInitialized) {\n', '            initialize();\n', '        }\n', '        _;\n', '    }\n', '\n', '    modifier onlyValidAddress(address account) {\n', '        require(account != 0x0);\n', '        _;\n', '    }\n', '\n', '    /* --- CONSTRUCTOR --- */\n', '\n', '    constructor(Minter _minter) public onlyValidAddress(address(_minter)) {\n', '        minter = _minter;\n', '    }\n', '\n', '    /* --- PUBLIC / EXTERNAL METHODS --- */\n', '\n', '    function dropMultiple(address[] accounts) external onlyOwner initialized {\n', '        require(accounts.length <= MAXIMUM_LOOP_BOUND);\n', '        for (uint i = 0; i < accounts.length; i++) {\n', '            drop(accounts[i]);\n', '        }\n', '    }\n', '\n', '    function drop(address account) public onlyOwner initialized notAlreadyDropped(account) {\n', '        dropped[account] = true;\n', '        uint contributed = minter.token().balanceOf(account);\n', '        uint tokenAmount = airdropPool.mul(contributed).div(initialTotalSupply);\n', '        minter.mint(account, ETHER_AMOUNT, tokenAmount);\n', '        emit Airdropped(account, tokenAmount);\n', '    }\n', '\n', '    /* --- INTERNAL METHODS --- */\n', '\n', '    function initialize() internal {\n', '        isInitialized = true;\n', '        initialTotalSupply = minter.token().totalSupply();\n', '        airdropPool = minter.token().cap().sub(initialTotalSupply);\n', '        emit Initialized();\n', '    }\n', '}']