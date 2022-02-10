['pragma solidity 0.4.24;\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * See https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address _who) public view returns (uint256);\n', '  function transfer(address _to, uint256 _value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address _owner, address _spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value)\n', '    public returns (bool);\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '  function safeTransfer(\n', '    ERC20Basic _token,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    internal\n', '  {\n', '    require(_token.transfer(_to, _value));\n', '  }\n', '\n', '  function safeTransferFrom(\n', '    ERC20 _token,\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    internal\n', '  {\n', '    require(_token.transferFrom(_from, _to, _value));\n', '  }\n', '\n', '  function safeApprove(\n', '    ERC20 _token,\n', '    address _spender,\n', '    uint256 _value\n', '  )\n', '    internal\n', '  {\n', '    require(_token.approve(_spender, _value));\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', "    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (_a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = _a * _b;\n', '    assert(c / _a == _b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    // assert(_b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = _a / _b;\n', "    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold\n", '    return _a / _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    assert(_b <= _a);\n', '    return _a - _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    c = _a + _b;\n', '    assert(c >= _a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Vesting trustee contract for CoyToken.\n', ' */\n', 'contract CoyVesting is Ownable {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    using SafeERC20 for ERC20;\n', '\n', '    ERC20 public token;\n', '\n', '    // Vesting grant for a specific holder.\n', '    struct Grant {\n', '        uint256 value;\n', '        uint256 start;\n', '        uint256 cliff;\n', '        uint256 end;\n', '        uint256 installmentLength; // In seconds.\n', '        uint256 transferred;\n', '        bool revocable;\n', '    }\n', '\n', '    // Holder to grant information mapping.\n', '    mapping (address => Grant) public grants;\n', '\n', '    // Total tokens available for vesting.\n', '    uint256 public totalVesting;\n', '\n', '    event NewGrant(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    event TokensUnlocked(address indexed _to, uint256 _value);\n', '\n', '    event GrantRevoked(address indexed _holder, uint256 _refund);\n', '\n', '    /**\n', '     * @dev Constructor that initializes the address of the CoyToken contract.\n', '     * @param _token CoyToken The address of the previously deployed CoyToken contract.\n', '     */\n', '    constructor(ERC20 _token) public {\n', '        require(_token != address(0), "Token must exist and cannot be 0 address.");\n', '        \n', '        token = _token;\n', '    }\n', '    \n', '    /**\n', '     * @dev Unlock vested tokens and transfer them to their holder.\n', '     */\n', '    function unlockVestedTokens() external {\n', '        Grant storage grant_ = grants[msg.sender];\n', '\n', '        // Require that the grant is not empty.\n', '        require(grant_.value != 0);\n', '        \n', '        // Get the total amount of vested tokens, according to grant.\n', '        uint256 vested = calculateVestedTokens(grant_, block.timestamp);\n', '        \n', '        if (vested == 0) {\n', '            return;\n', '        }\n', '        \n', "        // Make sure the holder doesn't transfer more than what he already has.\n", '        \n', '        uint256 transferable = vested.sub(grant_.transferred);\n', '        \n', '        if (transferable == 0) {\n', '            return;\n', '        }\n', '        \n', '        // Update transferred and total vesting amount, then transfer remaining vested funds to holder.\n', '        grant_.transferred = grant_.transferred.add(transferable);\n', '        totalVesting = totalVesting.sub(transferable);\n', '        \n', '        token.safeTransfer(msg.sender, transferable);\n', '\n', '        emit TokensUnlocked(msg.sender, transferable);\n', '    }\n', '\n', '    /**\n', '     * @dev Grant tokens to a specified address. Please note, that the trustee must have enough ungranted tokens\n', '     * to accomodate the new grant. Otherwise, the call with fail.\n', '     * @param _to address The holder address.\n', '     * @param _value uint256 The amount of tokens to be granted.\n', '     * @param _start uint256 The beginning of the vesting period.\n', '     * @param _cliff uint256 Point in time of the end of the cliff period (when the first installment is made).\n', '     * @param _end uint256 The end of the vesting period.\n', '     * @param _installmentLength uint256 The length of each vesting installment (in seconds).\n', '     * @param _revocable bool Whether the grant is revocable or not.\n', '     */\n', '    function granting(address _to, uint256 _value, uint256 _start, uint256 _cliff, uint256 _end,\n', '    uint256 _installmentLength, bool _revocable)\n', '    external onlyOwner \n', '    {    \n', '        require(_to != address(0));\n', '        \n', "        // Don't allow holder to be this contract.\n", '        require(_to != address(this));\n', '        \n', '        require(_value > 0);\n', '        \n', '        // Require that every holder can be granted tokens only once.\n', '        require(grants[_to].value == 0);\n', '        \n', '        // Require for time ranges to be consistent and valid.\n', '        require(_start <= _cliff && _cliff <= _end);\n', '        \n', '        // Require installment length to be valid and no longer than (end - start).\n', '        require(_installmentLength > 0 && _installmentLength <= _end.sub(_start));\n', '        \n', '        // Grant must not exceed the total amount of tokens currently available for vesting.\n', '        require(totalVesting.add(_value) <= token.balanceOf(address(this)));\n', '        \n', '        // Assign a new grant.\n', '        grants[_to] = Grant({\n', '            value: _value,\n', '            start: _start,\n', '            cliff: _cliff,\n', '            end: _end,\n', '            installmentLength: _installmentLength,\n', '            transferred: 0,\n', '            revocable: _revocable\n', '        });\n', '        \n', '        // Since tokens have been granted, increase the total amount available for vesting.\n', '        totalVesting = totalVesting.add(_value);\n', '        \n', '        emit NewGrant(msg.sender, _to, _value);\n', '    }\n', '    \n', '    /**\n', '     * @dev Calculate the total amount of vested tokens of a holder at a given time.\n', '     * @param _holder address The address of the holder.\n', '     * @param _time uint256 The specific time to calculate against.\n', "     * @return a uint256 Representing a holder's total amount of vested tokens.\n", '     */\n', '    function vestedTokens(address _holder, uint256 _time) external view returns (uint256) {\n', '        Grant memory grant_ = grants[_holder];\n', '        if (grant_.value == 0) {\n', '            return 0;\n', '        }\n', '        return calculateVestedTokens(grant_, _time);\n', '    }\n', '\n', '    /** \n', '     * @dev Revoke the grant of tokens of a specifed address.\n', '     * @param _holder The address which will have its tokens revoked.\n', '     */\n', '    function revoke(address _holder) public onlyOwner {\n', '        Grant memory grant_ = grants[_holder];\n', '\n', '        // Grant must be revocable.\n', '        require(grant_.revocable);\n', '\n', '        // Calculate amount of remaining tokens that are still available (i.e. not yet vested) to be returned to owner.\n', '        uint256 vested = calculateVestedTokens(grant_, block.timestamp);\n', '        \n', '        uint256 notTransferredInstallment = vested.sub(grant_.transferred);\n', '        \n', '        uint256 refund = grant_.value.sub(vested);\n', '        \n', '        //Update of transferred not necessary due to deletion of the grant in the following step.\n', '        \n', '        // Remove grant information.\n', '        delete grants[_holder];\n', '        \n', '        // Update total vesting amount and transfer previously calculated tokens to owner.\n', '        totalVesting = totalVesting.sub(refund).sub(notTransferredInstallment);\n', '        \n', '        // Transfer vested amount that was not yet transferred to _holder.\n', '        token.safeTransfer(_holder, notTransferredInstallment);\n', '        \n', '        emit TokensUnlocked(_holder, notTransferredInstallment);\n', '        \n', '        token.safeTransfer(msg.sender, refund);\n', '        \n', '        emit TokensUnlocked(msg.sender, refund);\n', '        \n', '        emit GrantRevoked(_holder, refund);\n', '    }\n', '\n', '    /**\n', '     * @dev Calculate amount of vested tokens at a specifc time.\n', '     * @param _grant Grant The vesting grant.\n', '     * @param _time uint256 The time to be checked\n', '     * @return a uint256 Representing the amount of vested tokens of a specific grant.\n', '     */\n', '    function calculateVestedTokens(Grant _grant, uint256 _time) private pure returns (uint256) {\n', "        // If we're before the cliff, then nothing is vested.\n", '        if (_time < _grant.cliff) {\n', '            return 0;\n', '        }\n', '       \n', "        // If we're after the end of the vesting period - everything is vested;\n", '        if (_time >= _grant.end) {\n', '            return _grant.value;\n', '        }\n', '       \n', '        // Calculate amount of installments past until now.\n', '        // NOTE result gets floored because of integer division.\n', '        uint256 installmentsPast = _time.sub(_grant.start).div(_grant.installmentLength);\n', '       \n', '        // Calculate amount of days in entire vesting period.\n', '        uint256 vestingDays = _grant.end.sub(_grant.start);\n', '       \n', '        // Calculate and return installments that have passed according to vesting days that have passed.\n', '        return _grant.value.mul(installmentsPast.mul(_grant.installmentLength)).div(vestingDays);\n', '    }\n', '}']