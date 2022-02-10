['pragma solidity 0.4.24;\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * See https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address _who) public view returns (uint256);\n', '  function transfer(address _to, uint256 _value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    // Gas optimization: this is cheaper than asserting &#39;a&#39; not being zero, but the\n', '    // benefit is lost if &#39;b&#39; is also tested.\n', '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (_a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = _a * _b;\n', '    assert(c / _a == _b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    // assert(_b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = _a / _b;\n', '    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn&#39;t hold\n', '    return _a / _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    assert(_b <= _a);\n', '    return _a - _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    c = _a + _b;\n', '    assert(c >= _a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) internal balances;\n', '\n', '  uint256 internal totalSupply_;\n', '\n', '  /**\n', '  * @dev Total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_value <= balances[msg.sender]);\n', '    require(_to != address(0));\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address _owner, address _spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value)\n', '    public returns (bool);\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * https://github.com/ethereum/EIPs/issues/20\n', ' * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '    require(_to != address(0));\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(\n', '    address _owner,\n', '    address _spender\n', '   )\n', '    public\n', '    view\n', '    returns (uint256)\n', '  {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(\n', '    address _spender,\n', '    uint256 _addedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    allowed[msg.sender][_spender] = (\n', '      allowed[msg.sender][_spender].add(_addedValue));\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(\n', '    address _spender,\n', '    uint256 _subtractedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    uint256 oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue >= oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', 'contract MintableToken is StandardToken, Ownable {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  modifier hasMintPermission() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(\n', '    address _to,\n', '    uint256 _amount\n', '  )\n', '    public\n', '    hasMintPermission\n', '    canMint\n', '    returns (bool)\n', '  {\n', '    totalSupply_ = totalSupply_.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    emit Mint(_to, _amount);\n', '    emit Transfer(address(0), _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() public onlyOwner canMint returns (bool) {\n', '    mintingFinished = true;\n', '    emit MintFinished();\n', '    return true;\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol\n', '\n', '/**\n', ' * @title DetailedERC20 token\n', ' * @dev The decimals are only for visualization purposes.\n', ' * All the operations are done using the smallest and indivisible token unit,\n', ' * just as on Ethereum all the operations are done in wei.\n', ' */\n', 'contract DetailedERC20 is ERC20 {\n', '  string public name;\n', '  string public symbol;\n', '  uint8 public decimals;\n', '\n', '  constructor(string _name, string _symbol, uint8 _decimals) public {\n', '    name = _name;\n', '    symbol = _symbol;\n', '    decimals = _decimals;\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol\n', '\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract BurnableToken is BasicToken {\n', '\n', '  event Burn(address indexed burner, uint256 value);\n', '\n', '  /**\n', '   * @dev Burns a specific amount of tokens.\n', '   * @param _value The amount of token to be burned.\n', '   */\n', '  function burn(uint256 _value) public {\n', '    _burn(msg.sender, _value);\n', '  }\n', '\n', '  function _burn(address _who, uint256 _value) internal {\n', '    require(_value <= balances[_who]);\n', '    // no need to require value <= totalSupply, since that would imply the\n', '    // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure\n', '\n', '    balances[_who] = balances[_who].sub(_value);\n', '    totalSupply_ = totalSupply_.sub(_value);\n', '    emit Burn(_who, _value);\n', '    emit Transfer(_who, address(0), _value);\n', '  }\n', '}\n', '\n', '// File: contracts/WhiteListManager.sol\n', '\n', 'contract WhiteListManager is Ownable {\n', '\n', '    // The list here will be updated by multiple separate WhiteList contracts\n', '    mapping (address => bool) public list;\n', '\n', '    function greylist(address addr) public onlyOwner {\n', '\n', '        list[addr] = false;\n', '    }\n', '\n', '    function greylistMany(address[] addrList) public onlyOwner {\n', '\n', '        for (uint256 i = 0; i < addrList.length; i++) {\n', '            \n', '            greylist(addrList[i]);\n', '        }\n', '    }\n', '\n', '    function whitelist(address addr) public onlyOwner {\n', '\n', '        list[addr] = true;\n', '    }\n', '\n', '    function whitelistMany(address[] addrList) public onlyOwner {\n', '\n', '        for (uint256 i = 0; i < addrList.length; i++) {\n', '            \n', '            whitelist(addrList[i]);\n', '        }\n', '    }\n', '\n', '    function isWhitelisted(address addr) public view returns (bool) {\n', '\n', '        return list[addr];\n', '    }\n', '}\n', '\n', '// File: contracts/Token.sol\n', '\n', 'contract MedipediaToken is MintableToken, BurnableToken, DetailedERC20, WhiteListManager{\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Every token amount must be multiplied by constant E18 to reflect decimals\n', '    // ------------------------------------------------------------------------\n', '    uint256 constant E18 = 10**18;\n', '\n', '    uint256 public constant BUSINESS_DEVELOPMENT_SUPPLY_LIMIT = 520000000 * E18; // 520,000,000 tokens\n', '    uint256 public constant MANAGEMENT_TEAM_SUPPLY_LIMIT = 520000000 * E18; // 520,000,000 tokens will be Locked for 18 Months\n', '    uint256 public constant ADVISORS_SUPPLY_LIMIT = 130000000 * E18; // 130,000,000 tokens will be Locked for 12 Months\n', '    uint256 public constant EARLY_INVESTORS_SUPPLY_LIMIT = 130000000 * E18; // 130,000,000 tokens will be Locked for 12 Months\n', '\n', '    // ------------------------------------------------------------------------\n', '    // INITIAL_SUPPLY =  BUSINESS_DEVELOPMENT_SUPPLY_LIMIT + MANAGEMENT_TEAM_SUPPLY_LIMIT +\n', '    //                   ADVISORS_SUPPLY_LIMIT + EARLY_INVESTORS_SUPPLY_LIMIT\n', '    // ------------------------------------------------------------------------\n', '    uint256 public constant INITIAL_SUPPLY = 1300000000 * E18;// 1.3 Billion tokens\n', '    uint256 public constant TOTAL_SUPPLY_LIMIT = 2600000000 * E18;// 2.6 Billion tokens\n', '\n', '    uint256 public constant TOKEN_SUPPLY_AIRDROP_LIMIT  = 15000000 * E18; // 15,000,000 tokens\n', '    uint256 public constant TOKEN_SUPPLY_BOUNTY_LIMIT   = 35000000 * E18; // 35,000,000 tokens\n', '\n', '    uint256 totalTokensIssuedToAdvisor;\n', '    uint256 totalTokensIssuedToEarlyInvestors;\n', '    uint256 totalTokensIssuedToMgmtTeam;\n', '\n', '    \n', '    uint256 releaseTimeToUnlockAdvisorTokens;\n', '    uint256 releaseTimeToUnlockEarlyInvestorTokens;\n', '    uint256 releaseTimeToUnlockManagementTokens;\n', '\n', '    bool public isICORunning;\n', '    address public icoContract;\n', '\n', '    uint256 public airDropTokenIssuedTotal;\n', '    uint256 public bountyTokenIssuedTotal;\n', '    uint256 public preICOTokenIssuedTotal;\n', '\n', '    uint8 private constant AIRDROP_EVENT = 1;\n', '    uint8 private constant BOUNTY_EVENT  = 2;\n', '    uint8 private constant PREICO_EVENT  = 3;\n', '    uint8 private constant ICO_EVENT     = 4;\n', '\n', '    event Released(uint256 amount);\n', '\n', '    constructor(string _name, string _symbol, uint8 _decimals) \n', '    DetailedERC20(_name, _symbol, _decimals) \n', '        public \n', '    {\n', '        balances[msg.sender] = BUSINESS_DEVELOPMENT_SUPPLY_LIMIT;\n', '        totalSupply_ = INITIAL_SUPPLY;\n', '\n', '        totalTokensIssuedToAdvisor = 0;\n', '        totalTokensIssuedToEarlyInvestors = 0;\n', '        totalTokensIssuedToMgmtTeam = 0;\n', '\n', '        airDropTokenIssuedTotal = 0;\n', '        bountyTokenIssuedTotal = 0;\n', '        preICOTokenIssuedTotal = 0;\n', '\n', '        //Epoch timestamps\n', '        releaseTimeToUnlockAdvisorTokens = 1566345600; // GMT: Wednesday, 21 August 2019 00:00:00\n', '        releaseTimeToUnlockEarlyInvestorTokens = 1566345600; // GMT: Wednesday, 21 August 2019 00:00:00\n', '        releaseTimeToUnlockManagementTokens = 1582243200; // GMT: Friday, 21 February 2020 00:00:00\n', '        \n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Contract should not accept ETH\n', '    // ------------------------------------------------------------------------\n', '    function () public payable {\n', '        revert();\n', '    }\n', '\n', '    /**\n', '   * @notice Transfers vested tokens to Advisor.\n', '   * @param _beneficiary ERC20 token which is being vested\n', '   * @param _releaseAmount ERC20 token which is being vested\n', '   */\n', '    function releaseToAdvisor(address _beneficiary, uint256 _releaseAmount) public onlyOwner{\n', '        require(isWhitelisted(_beneficiary), "Beneficiary is not whitelisted");\n', '        require(now >= releaseTimeToUnlockAdvisorTokens, "Release Advisor tokens on or after GMT: Wednesday, 21 August 2019 00:00:00");\n', '        \n', '        uint256 releaseAmount = _releaseAmount.mul(E18);\n', '        require(totalTokensIssuedToAdvisor.add(releaseAmount) <= ADVISORS_SUPPLY_LIMIT);\n', '\n', '        balances[_beneficiary] = balances[_beneficiary].add(releaseAmount);\n', '\n', '        totalTokensIssuedToAdvisor = totalTokensIssuedToAdvisor.add(releaseAmount);\n', '\n', '        emit Released(_releaseAmount);\n', '  }\n', '\n', '  /**\n', '   * @notice Transfers vested tokens to Early Investors.\n', '   * @param _beneficiary ERC20 token which is being vested\n', '   * @param _releaseAmount ERC20 token which is being vested\n', '   */\n', '    function releaseToEarlyInvestors(address _beneficiary, uint256 _releaseAmount) public onlyOwner{\n', '        require(isWhitelisted(_beneficiary), "Beneficiary is not whitelisted");\n', '        require(now >= releaseTimeToUnlockEarlyInvestorTokens, "Release Early Investors tokens on or after GMT: Wednesday, 21 August 2019 00:00:00");\n', '        \n', '        uint256 releaseAmount = _releaseAmount.mul(E18);\n', '        require(totalTokensIssuedToEarlyInvestors.add(releaseAmount) <= EARLY_INVESTORS_SUPPLY_LIMIT);\n', '\n', '        balances[_beneficiary] = balances[_beneficiary].add(releaseAmount);\n', '\n', '        totalTokensIssuedToEarlyInvestors = totalTokensIssuedToEarlyInvestors.add(releaseAmount);\n', '\n', '        emit Released(_releaseAmount);\n', '  }\n', '\n', '\n', '  /**\n', '   * @notice Transfers vested tokens to Management Team.\n', '   * @param _beneficiary ERC20 token which is being vested\n', '   * @param _releaseAmount ERC20 token which is being vested\n', '   */\n', '    function releaseToMgmtTeam(address _beneficiary, uint256 _releaseAmount) public onlyOwner{\n', '        require(isWhitelisted(_beneficiary), "Beneficiary is not whitelisted");\n', '        require(now >= releaseTimeToUnlockManagementTokens, "Release Mgmt Team tokens on or after GMT: Friday, 21 February 2020 00:00:00");\n', '        \n', '        uint256 releaseAmount = _releaseAmount.mul(E18);\n', '        require(totalTokensIssuedToMgmtTeam.add(releaseAmount) <= MANAGEMENT_TEAM_SUPPLY_LIMIT);\n', '\n', '        balances[_beneficiary] = balances[_beneficiary].add(releaseAmount);\n', '\n', '        totalTokensIssuedToMgmtTeam = totalTokensIssuedToMgmtTeam.add(releaseAmount);\n', '\n', '        emit Released(_releaseAmount);\n', '  }\n', '\n', '    /**\n', '     * @notice Start ICO.\n', '     * @param start bool value\n', '    */\n', '    function startICO(bool start) public onlyOwner{\n', '        isICORunning = start;\n', '    }\n', '\n', '    /**\n', '     * @notice Set the ICO smart contract address.\n', '     * @param _icoContract contract address of the ICO smart contract\n', '    */\n', '    function setIcoContract(address _icoContract) public onlyOwner {\n', '        \n', '        // Allow to set the ICO contract only once\n', '        require(icoContract == address(0));\n', '        require(_icoContract != address(0));\n', '\n', '        icoContract = _icoContract;\n', '    }\n', '\n', '    /**\n', '     * @notice Reward Airdrop Participant.\n', '     * @param _beneficiary wallet address of the Airdrop Participant\n', '     * @param _amount number of tokens to be rewarded\n', '    */\n', '    function rewardAirdrop(address _beneficiary, uint256 _amount) public onlyOwner {\n', '        require(isWhitelisted(_beneficiary), "Beneficiary is not whitelisted");\n', '\n', '        uint256 amount = _amount.mul(E18);\n', '        require (totalSupply_.add(amount) < TOTAL_SUPPLY_LIMIT);\n', '\n', '        require(amount <= TOKEN_SUPPLY_AIRDROP_LIMIT);\n', '\n', '        require(airDropTokenIssuedTotal < TOKEN_SUPPLY_AIRDROP_LIMIT);\n', '\n', '        uint256 remainingTokens = TOKEN_SUPPLY_AIRDROP_LIMIT.sub(airDropTokenIssuedTotal);\n', '        if (amount > remainingTokens) {\n', '            amount = remainingTokens;\n', '        }\n', '\n', '        balances[_beneficiary] = balances[_beneficiary].add(amount);\n', '\n', '        airDropTokenIssuedTotal = airDropTokenIssuedTotal.add(amount);\n', '        balances[msg.sender] = balances[msg.sender].sub(amount);\n', '\n', '        emit Transfer(address(AIRDROP_EVENT), _beneficiary, amount);\n', '    }\n', '\n', '    /**\n', '     * @notice Reward Bounty Participant.\n', '     * @param _beneficiary wallet address of the Bounty Participant\n', '     * @param _amount number of tokens to be rewarded\n', '    */\n', '    function rewardBounty(address _beneficiary, uint256 _amount) public onlyOwner {\n', '        require(isWhitelisted(_beneficiary), "Beneficiary is not whitelisted");\n', '        uint256 amount = _amount.mul(E18);\n', '        require (totalSupply_.add(amount) < TOTAL_SUPPLY_LIMIT);\n', '        require(amount <= TOKEN_SUPPLY_BOUNTY_LIMIT);\n', '\n', '        uint256 remainingTokens = TOKEN_SUPPLY_BOUNTY_LIMIT.sub(bountyTokenIssuedTotal);\n', '        if (amount > remainingTokens) {\n', '            amount = remainingTokens;\n', '        }\n', '\n', '        balances[_beneficiary] = balances[_beneficiary].add(amount);\n', '\n', '        bountyTokenIssuedTotal = bountyTokenIssuedTotal.add(amount);\n', '        balances[msg.sender] = balances[msg.sender].sub(amount);\n', '\n', '        emit Transfer(address(BOUNTY_EVENT), _beneficiary, amount);\n', '    }\n', '\n', '    /**\n', '     * @notice Pre ICO handler\n', '     * @param _beneficiary wallet address of the Pre ICO Buyer\n', '     * @param _amount number of tokens purchased\n', '    */\n', '    function preICO(address _beneficiary, uint256 _amount) public onlyOwner {\n', '        require(isWhitelisted(_beneficiary), "Buyer is not whitelisted");\n', '\n', '        uint256 amount = _amount.mul(E18);\n', '\n', '        require (totalSupply_.add(amount) <= TOTAL_SUPPLY_LIMIT);\n', '\n', '        uint256 remainingTokens = TOTAL_SUPPLY_LIMIT.sub(totalSupply_);\n', '\n', '        require (amount <= remainingTokens);\n', '\n', '        preICOTokenIssuedTotal = preICOTokenIssuedTotal.add(amount);\n', '\n', '        super.mint(_beneficiary, amount);\n', '\n', '        emit Transfer(address(PREICO_EVENT), _beneficiary, amount);\n', '    }\n', '\n', '    function preICOMany(address[] addrList, uint256[] amountList) public onlyOwner {\n', '\n', '        require(addrList.length == amountList.length);\n', '\n', '        for (uint256 i = 0; i < addrList.length; i++) {\n', '\n', '            preICO(addrList[i], amountList[i]);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @notice ICO handler\n', '     * @param buyer wallet address of the ICO Buyer\n', '     * @param tokens number of tokens purchased\n', '    */\n', '    function onICO(address buyer, uint256 tokens) public onlyOwner returns (bool success) {\n', '        require(isICORunning);\n', '        require(isWhitelisted(buyer), "Buyer is not whitelisted");\n', '        require (icoContract != address(0));\n', '        require (msg.sender == icoContract);\n', '        require (tokens > 0);\n', '        require (buyer != address(0));\n', '\n', '        require (totalSupply_.add(tokens) <= TOTAL_SUPPLY_LIMIT);\n', '\n', '        super.mint(buyer, tokens);\n', '        emit Transfer(address(ICO_EVENT), buyer, tokens);\n', '\n', '        return true;\n', '    }\n', '}']