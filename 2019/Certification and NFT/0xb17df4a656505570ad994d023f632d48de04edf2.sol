['pragma solidity >=0.5.0 <0.6.0;\n', '\n', 'interface INMR {\n', '\n', '    /* ERC20 Interface */\n', '\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address who) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    /* NMR Special Interface */\n', '\n', '    // used for user balance management\n', '    function withdraw(address _from, address _to, uint256 _value) external returns(bool ok);\n', '\n', '    // used for migrating active stakes\n', '    function destroyStake(address _staker, bytes32 _tag, uint256 _tournamentID, uint256 _roundID) external returns (bool ok);\n', '\n', '    // used for disabling token upgradability\n', '    function createRound(uint256, uint256, uint256, uint256) external returns (bool ok);\n', '\n', '    // used for upgrading the token delegate logic\n', '    function createTournament(uint256 _newDelegate) external returns (bool ok);\n', '\n', '    // used like burn(uint256)\n', '    function mint(uint256 _value) external returns (bool ok);\n', '\n', '    // used like burnFrom(address, uint256)\n', '    function numeraiTransfer(address _to, uint256 _value) external returns (bool ok);\n', '\n', '    // used to check if upgrade completed\n', '    function contractUpgradable() external view returns (bool);\n', '\n', '    function getTournament(uint256 _tournamentID) external view returns (uint256, uint256[] memory);\n', '\n', '    function getRound(uint256 _tournamentID, uint256 _roundID) external view returns (uint256, uint256, uint256);\n', '\n', '    function getStake(uint256 _tournamentID, uint256 _roundID, address _staker, bytes32 _tag) external view returns (uint256, uint256, bool, bool);\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Initializable\n', ' *\n', ' * @dev Helper contract to support initializer functions. To use it, replace\n', ' * the constructor with a function that has the `initializer` modifier.\n', ' * WARNING: Unlike constructors, initializer functions must be manually\n', ' * invoked. This applies both to deploying an Initializable contract, as well\n', ' * as extending an Initializable contract via inheritance.\n', ' * WARNING: When used with inheritance, manual care must be taken to not invoke\n', ' * a parent initializer twice, or ensure that all initializers are idempotent,\n', ' * because this is not dealt with automatically as with constructors.\n', ' */\n', 'contract Initializable {\n', '\n', '  /**\n', '   * @dev Indicates that the contract has been initialized.\n', '   */\n', '  bool private initialized;\n', '\n', '  /**\n', '   * @dev Indicates that the contract is in the process of being initialized.\n', '   */\n', '  bool private initializing;\n', '\n', '  /**\n', '   * @dev Modifier to use in the initializer function of a contract.\n', '   */\n', '  modifier initializer() {\n', '    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");\n', '\n', '    bool wasInitializing = initializing;\n', '    initializing = true;\n', '    initialized = true;\n', '\n', '    _;\n', '\n', '    initializing = wasInitializing;\n', '  }\n', '\n', '  /// @dev Returns true if and only if the function is running in the constructor\n', '  function isConstructor() private view returns (bool) {\n', '    // extcodesize checks the size of the code stored in an address, and\n', '    // address returns the current address. Since the code is still not\n', '    // deployed when running a constructor, any checks on its code size will\n', '    // yield zero, making it an effective way to detect if a contract is\n', '    // under construction or not.\n', '    uint256 cs;\n', '    assembly { cs := extcodesize(address) }\n', '    return cs == 0;\n', '  }\n', '\n', '  // Reserved storage space to allow for layout changes in the future.\n', '  uint256[50] private ______gap;\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable is Initializable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function initialize(address sender) public initializer {\n', '        _owner = sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @return the address of the owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner());\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @return true if `msg.sender` is the owner of the contract.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to relinquish control of the contract.\n', '     * @notice Renouncing to ownership will leave the contract without an owner.\n', '     * It will not be possible to call the functions with the `onlyOwner`\n', '     * modifier anymore.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '\n', '    uint256[50] private ______gap;\n', '}\n', '\n', '\n', '\n', 'contract Manageable is Initializable, Ownable {\n', '    address private _manager;\n', '\n', '    event ManagementTransferred(address indexed previousManager, address indexed newManager);\n', '\n', '    /**\n', '     * @dev The Managable constructor sets the original `manager` of the contract to the sender\n', '     * account.\n', '     */\n', '    function initialize(address sender) initializer public {\n', '        Ownable.initialize(sender);\n', '        _manager = sender;\n', '        emit ManagementTransferred(address(0), _manager);\n', '    }\n', '\n', '    /**\n', '     * @return the address of the manager.\n', '     */\n', '    function manager() public view returns (address) {\n', '        return _manager;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner or manager.\n', '     */\n', '    modifier onlyManagerOrOwner() {\n', '        require(isManagerOrOwner());\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @return true if `msg.sender` is the owner or manager of the contract.\n', '     */\n', '    function isManagerOrOwner() public view returns (bool) {\n', '        return (msg.sender == _manager || isOwner());\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newManager.\n', '     * @param newManager The address to transfer management to.\n', '     */\n', '    function transferManagement(address newManager) public onlyOwner {\n', '        require(newManager != address(0));\n', '        emit ManagementTransferred(_manager, newManager);\n', '        _manager = newManager;\n', '    }\n', '\n', '    uint256[50] private ______gap;\n', '}\n', '\n', '\n', '\n', 'contract Relay is Manageable {\n', '\n', '    bool public active = true;\n', '    bool private _upgraded;\n', '\n', '    // set NMR token, 1M address, null address, burn address as constants\n', '    address private constant _TOKEN = address(\n', '        0x1776e1F26f98b1A5dF9cD347953a26dd3Cb46671\n', '    );\n', '    address private constant _ONE_MILLION_ADDRESS = address(\n', '        0x00000000000000000000000000000000000F4240\n', '    );    \n', '    address private constant _NULL_ADDRESS = address(\n', '        0x0000000000000000000000000000000000000000\n', '    );\n', '    address private constant _BURN_ADDRESS = address(\n', '        0x000000000000000000000000000000000000dEaD\n', '    );\n', '\n', '    /// @dev Throws if the address does not match the required conditions.\n', '    modifier isUser(address _user) {\n', '        require(\n', '            _user <= _ONE_MILLION_ADDRESS\n', '            && _user != _NULL_ADDRESS\n', '            && _user != _BURN_ADDRESS\n', '            , "_from must be a user account managed by Numerai"\n', '        );\n', '        _;\n', '    }\n', '\n', '    /// @dev Throws if called after the relay is disabled.\n', '    modifier onlyActive() {\n', '        require(active, "User account relay has been disabled");\n', '        _;\n', '    }\n', '\n', '    /// @notice Contructor function called at time of deployment\n', '    /// @param _owner The initial owner and manager of the relay\n', '    constructor(address _owner) public {\n', '        require(\n', '            address(this) == address(0xB17dF4a656505570aD994D023F632D48De04eDF2),\n', '            "incorrect deployment address - check submitting account & nonce."\n', '        );\n', '\n', '        Manageable.initialize(_owner);\n', '    }\n', '\n', '    /// @notice Transfer NMR on behalf of a Numerai user\n', '    ///         Can only be called by Manager or Owner\n', '    /// @dev Can only be used on the first 1 million ethereum addresses\n', '    /// @param _from The user address\n', '    /// @param _to The recipient address\n', '    /// @param _value The amount of NMR in wei\n', '    function withdraw(address _from, address _to, uint256 _value) public onlyManagerOrOwner onlyActive isUser(_from) returns (bool ok) {\n', '        require(INMR(_TOKEN).withdraw(_from, _to, _value));\n', '        return true;\n', '    }\n', '\n', '    /// @notice Burn the NMR sent to address 0 and burn address\n', '    function burnZeroAddress() public {\n', '        uint256 amtZero = INMR(_TOKEN).balanceOf(_NULL_ADDRESS);\n', '        uint256 amtBurn = INMR(_TOKEN).balanceOf(_BURN_ADDRESS);\n', '        require(INMR(_TOKEN).withdraw(_NULL_ADDRESS, address(this), amtZero));\n', '        require(INMR(_TOKEN).withdraw(_BURN_ADDRESS, address(this), amtBurn));\n', '        uint256 amtThis = INMR(_TOKEN).balanceOf(address(this));\n', '        _burn(amtThis);\n', '    }\n', '\n', '    /// @notice Permanantly disable the relay contract\n', '    ///         Can only be called by Owner\n', '    function disable() public onlyOwner onlyActive {\n', '        active = false;\n', '    }\n', '\n', '    /// @notice Permanantly disable token upgradability\n', '    ///         Can only be called by Owner\n', '    function disableTokenUpgradability() public onlyOwner onlyActive {\n', '        require(INMR(_TOKEN).createRound(uint256(0),uint256(0),uint256(0),uint256(0)));\n', '    }\n', '\n', '    /// @notice Upgrade the token delegate logic.\n', '    ///         Can only be called by Owner\n', '    /// @param _newDelegate Address of the new delegate contract\n', '    function changeTokenDelegate(address _newDelegate) public onlyOwner onlyActive {\n', '        require(INMR(_TOKEN).createTournament(uint256(_newDelegate)));\n', '    }\n', '\n', '    /// @notice Get the address of the NMR token contract\n', '    /// @return The address of the NMR token contract\n', '    function token() external pure returns (address) {\n', '        return _TOKEN;\n', '    }\n', '\n', '    /// @notice Internal helper function to burn NMR\n', '    /// @dev If before the token upgrade, sends the tokens to address 0\n', '    ///      If after the token upgrade, calls the repurposed mint function to burn\n', '    /// @param _value The amount of NMR in wei\n', '    function _burn(uint256 _value) internal {\n', '        if (INMR(_TOKEN).contractUpgradable()) {\n', '            require(INMR(_TOKEN).transfer(address(0), _value));\n', '        } else {\n', '            require(INMR(_TOKEN).mint(_value), "burn not successful");\n', '        }\n', '    }\n', '}']