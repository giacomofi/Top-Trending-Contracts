['pragma solidity ^0.4.17;\n', '/**\n', ' * @title ERC20\n', ' * @dev ERC20 interface\n', ' */\n', 'contract ERC20 {\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', 'contract Controlled {\n', '    /// @notice The address of the controller is the only address that can call\n', '    ///  a function with this modifier\n', '    modifier onlyController { require(msg.sender == controller); _; }\n', '    address public controller;\n', '    function Controlled() public { controller = msg.sender;}\n', '    /// @notice Changes the controller of the contract\n', '    /// @param _newController The new controller of the contract\n', '    function changeController(address _newController) public onlyController {\n', '        controller = _newController;\n', '    }\n', '}\n', '/**\n', ' * @title MiniMe interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20MiniMe is ERC20, Controlled {\n', '    function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool);\n', '    function totalSupply() public view returns (uint);\n', '    function balanceOfAt(address _owner, uint _blockNumber) public view returns (uint);\n', '    function totalSupplyAt(uint _blockNumber) public view returns(uint);\n', '    function createCloneToken(string _cloneTokenName, uint8 _cloneDecimalUnits, string _cloneTokenSymbol, uint _snapshotBlock, bool _transfersEnabled) public returns(address);\n', '    function generateTokens(address _owner, uint _amount) public returns (bool);\n', '    function destroyTokens(address _owner, uint _amount)  public returns (bool);\n', '    function enableTransfers(bool _transfersEnabled) public;\n', '    function isContract(address _addr) internal view returns(bool);\n', '    function claimTokens(address _token) public;\n', '    event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);\n', '    event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);\n', '}\n', '/// @dev The token controller contract must implement these functions\n', 'contract TokenController {\n', '    ERC20MiniMe public ethealToken;\n', '    address public SALE; // address where sale tokens are located\n', '    /// @notice needed for hodler handling\n', '    function addHodlerStake(address _beneficiary, uint _stake) public;\n', '    function setHodlerStake(address _beneficiary, uint256 _stake) public;\n', '    function setHodlerTime(uint256 _time) public;\n', '    /// @notice Called when `_owner` sends ether to the MiniMe Token contract\n', '    /// @param _owner The address that sent the ether to create tokens\n', '    /// @return True if the ether is accepted, false if it throws\n', '    function proxyPayment(address _owner) public payable returns(bool);\n', '    /// @notice Notifies the controller about a token transfer allowing the\n', '    ///  controller to react if desired\n', '    /// @param _from The origin of the transfer\n', '    /// @param _to The destination of the transfer\n', '    /// @param _amount The amount of the transfer\n', '    /// @return False if the controller does not authorize the transfer\n', '    function onTransfer(address _from, address _to, uint _amount) public returns(bool);\n', '    /// @notice Notifies the controller about an approval allowing the\n', '    ///  controller to react if desired\n', '    /// @param _owner The address that calls `approve()`\n', '    /// @param _spender The spender in the `approve()` call\n', '    /// @param _amount The amount in the `approve()` call\n', '    /// @return False if the controller does not authorize the approval\n', '    function onApprove(address _owner, address _spender, uint _amount) public returns(bool);\n', '}\n', '/**\n', ' * @title Hodler\n', ' * @dev Handles hodler reward, TokenController should create and own it.\n', ' */\n', 'contract Hodler is Ownable {\n', '    using SafeMath for uint;\n', '    // HODLER reward tracker\n', '    // stake amount per address\n', '    struct HODL {\n', '        uint256 stake;\n', '        // moving ANY funds invalidates hodling of the address\n', '        bool invalid;\n', '        bool claimed3M;\n', '        bool claimed6M;\n', '        bool claimed9M;\n', '    }\n', '    mapping (address => HODL) public hodlerStakes;\n', '    // total current staking value and hodler addresses\n', '    uint256 public hodlerTotalValue;\n', '    uint256 public hodlerTotalCount;\n', '    // store dates and total stake values for 3 - 6 - 9 months after normal sale\n', '    uint256 public hodlerTotalValue3M;\n', '    uint256 public hodlerTotalValue6M;\n', '    uint256 public hodlerTotalValue9M;\n', '    uint256 public hodlerTimeStart;\n', '    uint256 public hodlerTime3M;\n', '    uint256 public hodlerTime6M;\n', '    uint256 public hodlerTime9M;\n', '    // reward HEAL token amount\n', '    uint256 public TOKEN_HODL_3M;\n', '    uint256 public TOKEN_HODL_6M;\n', '    uint256 public TOKEN_HODL_9M;\n', '    // total amount of tokens claimed so far\n', '    uint256 public claimedTokens;\n', '    \n', '    event LogHodlSetStake(address indexed _setter, address indexed _beneficiary, uint256 _value);\n', '    event LogHodlClaimed(address indexed _setter, address indexed _beneficiary, uint256 _value);\n', '    event LogHodlStartSet(address indexed _setter, uint256 _time);\n', '    /// @dev Only before hodl is started\n', '    modifier beforeHodlStart() {\n', '        if (hodlerTimeStart == 0 || now <= hodlerTimeStart)\n', '            _;\n', '    }\n', '    /// @dev Contructor, it should be created by a TokenController\n', '    function Hodler(uint256 _stake3m, uint256 _stake6m, uint256 _stake9m) {\n', '        TOKEN_HODL_3M = _stake3m;\n', '        TOKEN_HODL_6M = _stake6m;\n', '        TOKEN_HODL_9M = _stake9m;\n', '    }\n', '    /// @notice Adding hodler stake to an account\n', '    /// @dev Only owner contract can call it and before hodling period starts\n', '    /// @param _beneficiary Recepient address of hodler stake\n', '    /// @param _stake Amount of additional hodler stake\n', '    function addHodlerStake(address _beneficiary, uint256 _stake) public onlyOwner beforeHodlStart {\n', '        // real change and valid _beneficiary is needed\n', '        if (_stake == 0 || _beneficiary == address(0))\n', '            return;\n', '        \n', '        // add stake and maintain count\n', '        if (hodlerStakes[_beneficiary].stake == 0)\n', '            hodlerTotalCount = hodlerTotalCount.add(1);\n', '        hodlerStakes[_beneficiary].stake = hodlerStakes[_beneficiary].stake.add(_stake);\n', '        hodlerTotalValue = hodlerTotalValue.add(_stake);\n', '        LogHodlSetStake(msg.sender, _beneficiary, hodlerStakes[_beneficiary].stake);\n', '    }\n', '    /// @notice Setting hodler stake of an account\n', '    /// @dev Only owner contract can call it and before hodling period starts\n', '    /// @param _beneficiary Recepient address of hodler stake\n', '    /// @param _stake Amount to set the hodler stake\n', '    function setHodlerStake(address _beneficiary, uint256 _stake) public onlyOwner beforeHodlStart {\n', '        // real change and valid _beneficiary is needed\n', '        if (hodlerStakes[_beneficiary].stake == _stake || _beneficiary == address(0))\n', '            return;\n', '        \n', '        // add stake and maintain count\n', '        if (hodlerStakes[_beneficiary].stake == 0 && _stake > 0) {\n', '            hodlerTotalCount = hodlerTotalCount.add(1);\n', '        } else if (hodlerStakes[_beneficiary].stake > 0 && _stake == 0) {\n', '            hodlerTotalCount = hodlerTotalCount.sub(1);\n', '        }\n', '        uint256 _diff = _stake > hodlerStakes[_beneficiary].stake ? _stake.sub(hodlerStakes[_beneficiary].stake) : hodlerStakes[_beneficiary].stake.sub(_stake);\n', '        if (_stake > hodlerStakes[_beneficiary].stake) {\n', '            hodlerTotalValue = hodlerTotalValue.add(_diff);\n', '        } else {\n', '            hodlerTotalValue = hodlerTotalValue.sub(_diff);\n', '        }\n', '        hodlerStakes[_beneficiary].stake = _stake;\n', '        LogHodlSetStake(msg.sender, _beneficiary, _stake);\n', '    }\n', '    /// @notice Setting hodler start period.\n', '    /// @param _time The time when hodler reward starts counting\n', '    function setHodlerTime(uint256 _time) public onlyOwner beforeHodlStart {\n', '        require(_time >= now);\n', '        hodlerTimeStart = _time;\n', '        hodlerTime3M = _time.add(90 days);\n', '        hodlerTime6M = _time.add(180 days);\n', '        hodlerTime9M = _time.add(270 days);\n', '        LogHodlStartSet(msg.sender, _time);\n', '    }\n', '    /// @notice Invalidates hodler account \n', '    /// @dev Gets called by EthealController#onTransfer before every transaction\n', '    function invalidate(address _account) public onlyOwner {\n', '        if (hodlerStakes[_account].stake > 0 && !hodlerStakes[_account].invalid) {\n', '            hodlerStakes[_account].invalid = true;\n', '            hodlerTotalValue = hodlerTotalValue.sub(hodlerStakes[_account].stake);\n', '            hodlerTotalCount = hodlerTotalCount.sub(1);\n', '        }\n', '        // update hodl total values "automatically" - whenever someone sends funds thus\n', '        updateAndGetHodlTotalValue();\n', '    }\n', '    /// @notice Claiming HODL reward for msg.sender\n', '    function claimHodlReward() public {\n', '        claimHodlRewardFor(msg.sender);\n', '    }\n', '    /// @notice Claiming HODL reward for an address\n', '    function claimHodlRewardFor(address _beneficiary) public {\n', '        // only when the address has a valid stake\n', '        require(hodlerStakes[_beneficiary].stake > 0 && !hodlerStakes[_beneficiary].invalid);\n', '        uint256 _stake = 0;\n', '        \n', '        // update hodl total values\n', '        updateAndGetHodlTotalValue();\n', '        // claim hodl if not claimed\n', '        if (!hodlerStakes[_beneficiary].claimed3M && now >= hodlerTime3M) {\n', '            _stake = _stake.add(hodlerStakes[_beneficiary].stake.mul(TOKEN_HODL_3M).div(hodlerTotalValue3M));\n', '            hodlerStakes[_beneficiary].claimed3M = true;\n', '        }\n', '        if (!hodlerStakes[_beneficiary].claimed6M && now >= hodlerTime6M) {\n', '            _stake = _stake.add(hodlerStakes[_beneficiary].stake.mul(TOKEN_HODL_6M).div(hodlerTotalValue6M));\n', '            hodlerStakes[_beneficiary].claimed6M = true;\n', '        }\n', '        if (!hodlerStakes[_beneficiary].claimed9M && now >= hodlerTime9M) {\n', '            _stake = _stake.add(hodlerStakes[_beneficiary].stake.mul(TOKEN_HODL_9M).div(hodlerTotalValue9M));\n', '            hodlerStakes[_beneficiary].claimed9M = true;\n', '        }\n', '        if (_stake > 0) {\n', '            // increasing claimed tokens\n', '            claimedTokens = claimedTokens.add(_stake);\n', '            // transferring tokens\n', '            require(TokenController(owner).ethealToken().transfer(_beneficiary, _stake));\n', '            // log\n', '            LogHodlClaimed(msg.sender, _beneficiary, _stake);\n', '        }\n', '    }\n', '    /// @notice claimHodlRewardFor() for multiple addresses\n', '    /// @dev Anyone can call this function and distribute hodl rewards\n', '    /// @param _beneficiaries Array of addresses for which we want to claim hodl rewards\n', '    function claimHodlRewardsFor(address[] _beneficiaries) external {\n', '        for (uint256 i = 0; i < _beneficiaries.length; i++)\n', '            claimHodlRewardFor(_beneficiaries[i]);\n', '    }\n', '    /// @notice Setting 3 - 6 - 9 months total staking hodl value if time is come\n', '    function updateAndGetHodlTotalValue() public returns (uint) {\n', '        if (now >= hodlerTime3M && hodlerTotalValue3M == 0) {\n', '            hodlerTotalValue3M = hodlerTotalValue;\n', '        }\n', '        if (now >= hodlerTime6M && hodlerTotalValue6M == 0) {\n', '            hodlerTotalValue6M = hodlerTotalValue;\n', '        }\n', '        if (now >= hodlerTime9M && hodlerTotalValue9M == 0) {\n', '            hodlerTotalValue9M = hodlerTotalValue;\n', '            // since we can transfer more tokens to this contract, make it possible to retain more than the predefined limit\n', '            TOKEN_HODL_9M = TokenController(owner).ethealToken().balanceOf(this).sub(TOKEN_HODL_3M).sub(TOKEN_HODL_6M).add(claimedTokens);\n', '        }\n', '        return hodlerTotalValue;\n', '    }\n', '}']