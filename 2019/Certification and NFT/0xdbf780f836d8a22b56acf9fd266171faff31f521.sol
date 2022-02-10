['pragma solidity ^0.4.24;\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/HasNoEther.sol\n', '\n', '/**\n', ' * @title Contracts that should not own Ether\n', ' * @author Remco Bloemen <remco@2π.com>\n', ' * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up\n', ' * in the contract, it will allow the owner to reclaim this Ether.\n', ' * @notice Ether can still be sent to this contract by:\n', ' * calling functions labeled `payable`\n', ' * `selfdestruct(contract_address)`\n', ' * mining directly to the contract address\n', ' */\n', 'contract HasNoEther is Ownable {\n', '\n', '  /**\n', '  * @dev Constructor that rejects incoming Ether\n', '  * The `payable` flag is added so we can access `msg.value` without compiler warning. If we\n', '  * leave out payable, then Solidity will allow inheriting contracts to implement a payable\n', '  * constructor. By doing it this way we prevent a payable constructor from working. Alternatively\n', '  * we could use assembly to access msg.value.\n', '  */\n', '  constructor() public payable {\n', '    require(msg.value == 0);\n', '  }\n', '\n', '  /**\n', '   * @dev Disallows direct send by setting a default function without the `payable` flag.\n', '   */\n', '  function() external {\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer all Ether held by the contract to the owner.\n', '   */\n', '  function reclaimEther() external onlyOwner {\n', '    owner.transfer(address(this).balance);\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * See https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address _who) public view returns (uint256);\n', '  function transfer(address _to, uint256 _value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address _owner, address _spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value)\n', '    public returns (bool);\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '  function safeTransfer(\n', '    ERC20Basic _token,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    internal\n', '  {\n', '    require(_token.transfer(_to, _value));\n', '  }\n', '\n', '  function safeTransferFrom(\n', '    ERC20 _token,\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    internal\n', '  {\n', '    require(_token.transferFrom(_from, _to, _value));\n', '  }\n', '\n', '  function safeApprove(\n', '    ERC20 _token,\n', '    address _spender,\n', '    uint256 _value\n', '  )\n', '    internal\n', '  {\n', '    require(_token.approve(_spender, _value));\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol\n', '\n', '/**\n', ' * @title Contracts that should be able to recover tokens\n', ' * @author SylTi\n', ' * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.\n', ' * This will prevent any accidental loss of tokens.\n', ' */\n', 'contract CanReclaimToken is Ownable {\n', '  using SafeERC20 for ERC20Basic;\n', '\n', '  /**\n', '   * @dev Reclaim all ERC20Basic compatible tokens\n', '   * @param _token ERC20Basic The address of the token contract\n', '   */\n', '  function reclaimToken(ERC20Basic _token) external onlyOwner {\n', '    uint256 balance = _token.balanceOf(this);\n', '    _token.safeTransfer(owner, balance);\n', '  }\n', '\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/HasNoTokens.sol\n', '\n', '/**\n', ' * @title Contracts that should not own Tokens\n', ' * @author Remco Bloemen <remco@2π.com>\n', ' * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.\n', ' * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the\n', ' * owner to reclaim the tokens.\n', ' */\n', 'contract HasNoTokens is CanReclaimToken {\n', '\n', ' /**\n', '  * @dev Reject all ERC223 compatible tokens\n', '  * @param _from address The address that is transferring the tokens\n', '  * @param _value uint256 the amount of the specified token\n', '  * @param _data Bytes The data passed from the caller.\n', '  */\n', '  function tokenFallback(\n', '    address _from,\n', '    uint256 _value,\n', '    bytes _data\n', '  )\n', '    external\n', '    pure\n', '  {\n', '    _from;\n', '    _value;\n', '    _data;\n', '    revert();\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/ownership/OwnableProxy.sol\n', '\n', '/**\n', ' * @title OwnableProxy\n', ' */\n', 'contract OwnableProxy {\n', '    event OwnershipRenounced(address indexed previousOwner);\n', '    event OwnershipTransferred(\n', '        address indexed previousOwner,\n', '        address indexed newOwner\n', '    );\n', '\n', '    /**\n', '     * @dev Storage slot with the owner of the contract.\n', '     * This is the keccak-256 hash of "org.monetha.proxy.owner", and is\n', '     * validated in the constructor.\n', '     */\n', '    bytes32 private constant OWNER_SLOT = 0x3ca57e4b51fc2e18497b219410298879868edada7e6fe5132c8feceb0a080d22;\n', '\n', '    /**\n', '     * @dev The OwnableProxy constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor() public {\n', '        assert(OWNER_SLOT == keccak256("org.monetha.proxy.owner"));\n', '\n', '        _setOwner(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == _getOwner());\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to relinquish control of the contract.\n', '     * @notice Renouncing to ownership will leave the contract without an owner.\n', '     * It will not be possible to call the functions with the `onlyOwner`\n', '     * modifier anymore.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipRenounced(_getOwner());\n', '        _setOwner(address(0));\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param _newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        _transferOwnership(_newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers control of the contract to a newOwner.\n', '     * @param _newOwner The address to transfer ownership to.\n', '     */\n', '    function _transferOwnership(address _newOwner) internal {\n', '        require(_newOwner != address(0));\n', '        emit OwnershipTransferred(_getOwner(), _newOwner);\n', '        _setOwner(_newOwner);\n', '    }\n', '\n', '    /**\n', '     * @return The owner address.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _getOwner();\n', '    }\n', '\n', '    /**\n', '     * @return The owner address.\n', '     */\n', '    function _getOwner() internal view returns (address own) {\n', '        bytes32 slot = OWNER_SLOT;\n', '        assembly {\n', '            own := sload(slot)\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Sets the address of the proxy owner.\n', '     * @param _newOwner Address of the new proxy owner.\n', '     */\n', '    function _setOwner(address _newOwner) internal {\n', '        bytes32 slot = OWNER_SLOT;\n', '\n', '        assembly {\n', '            sstore(slot, _newOwner)\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/ownership/ClaimableProxy.sol\n', '\n', '/**\n', ' * @title ClaimableProxy\n', ' * @dev Extension for the OwnableProxy contract, where the ownership needs to be claimed.\n', ' * This allows the new owner to accept the transfer.\n', ' */\n', 'contract ClaimableProxy is OwnableProxy {\n', '    /**\n', '     * @dev Storage slot with the pending owner of the contract.\n', '     * This is the keccak-256 hash of "org.monetha.proxy.pendingOwner", and is\n', '     * validated in the constructor.\n', '     */\n', '    bytes32 private constant PENDING_OWNER_SLOT = 0xcfd0c6ea5352192d7d4c5d4e7a73c5da12c871730cb60ff57879cbe7b403bb52;\n', '\n', '    /**\n', '     * @dev The ClaimableProxy constructor validates PENDING_OWNER_SLOT constant.\n', '     */\n', '    constructor() public {\n', '        assert(PENDING_OWNER_SLOT == keccak256("org.monetha.proxy.pendingOwner"));\n', '    }\n', '\n', '    function pendingOwner() public view returns (address) {\n', '        return _getPendingOwner();\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier throws if called by any account other than the pendingOwner.\n', '     */\n', '    modifier onlyPendingOwner() {\n', '        require(msg.sender == _getPendingOwner());\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to set the pendingOwner address.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _setPendingOwner(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the pendingOwner address to finalize the transfer.\n', '     */\n', '    function claimOwnership() public onlyPendingOwner {\n', '        emit OwnershipTransferred(_getOwner(), _getPendingOwner());\n', '        _setOwner(_getPendingOwner());\n', '        _setPendingOwner(address(0));\n', '    }\n', '\n', '    /**\n', '     * @return The pending owner address.\n', '     */\n', '    function _getPendingOwner() internal view returns (address penOwn) {\n', '        bytes32 slot = PENDING_OWNER_SLOT;\n', '        assembly {\n', '            penOwn := sload(slot)\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Sets the address of the pending owner.\n', '     * @param _newPendingOwner Address of the new pending owner.\n', '     */\n', '    function _setPendingOwner(address _newPendingOwner) internal {\n', '        bytes32 slot = PENDING_OWNER_SLOT;\n', '\n', '        assembly {\n', '            sstore(slot, _newPendingOwner)\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/lifecycle/DestructibleProxy.sol\n', '\n', '/**\n', ' * @title Destructible\n', ' * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.\n', ' */\n', 'contract DestructibleProxy is OwnableProxy {\n', '    /**\n', '     * @dev Transfers the current balance to the owner and terminates the contract.\n', '     */\n', '    function destroy() public onlyOwner {\n', '        selfdestruct(_getOwner());\n', '    }\n', '\n', '    function destroyAndSend(address _recipient) public onlyOwner {\n', '        selfdestruct(_recipient);\n', '    }\n', '}\n', '\n', '// File: contracts/IPassportLogicRegistry.sol\n', '\n', 'interface IPassportLogicRegistry {\n', '    /**\n', '     * @dev This event will be emitted every time a new passport logic implementation is registered\n', '     * @param version representing the version name of the registered passport logic implementation\n', '     * @param implementation representing the address of the registered passport logic implementation\n', '     */\n', '    event PassportLogicAdded(string version, address implementation);\n', '\n', '    /**\n', '     * @dev This event will be emitted every time a new passport logic implementation is set as current one\n', '     * @param version representing the version name of the current passport logic implementation\n', '     * @param implementation representing the address of the current passport logic implementation\n', '     */\n', '    event CurrentPassportLogicSet(string version, address implementation);\n', '\n', '    /**\n', '     * @dev Tells the address of the passport logic implementation for a given version\n', '     * @param _version to query the implementation of\n', '     * @return address of the passport logic implementation registered for the given version\n', '     */\n', '    function getPassportLogic(string _version) external view returns (address);\n', '\n', '    /**\n', '     * @dev Tells the version of the current passport logic implementation\n', '     * @return version of the current passport logic implementation\n', '     */\n', '    function getCurrentPassportLogicVersion() external view returns (string);\n', '\n', '    /**\n', '     * @dev Tells the address of the current passport logic implementation\n', '     * @return address of the current passport logic implementation\n', '     */\n', '    function getCurrentPassportLogic() external view returns (address);\n', '}\n', '\n', '// File: contracts/upgradeability/Proxy.sol\n', '\n', '/**\n', ' * @title Proxy\n', ' * @dev Implements delegation of calls to other contracts, with proper\n', ' * forwarding of return values and bubbling of failures.\n', ' * It defines a fallback function that delegates all calls to the address\n', ' * returned by the abstract _implementation() internal function.\n', ' */\n', 'contract Proxy {\n', '    /**\n', '     * @dev Fallback function.\n', '     * Implemented entirely in `_fallback`.\n', '     */\n', '    function () payable external {\n', '        _delegate(_implementation());\n', '    }\n', '\n', '    /**\n', '     * @return The Address of the implementation.\n', '     */\n', '    function _implementation() internal view returns (address);\n', '\n', '    /**\n', '     * @dev Delegates execution to an implementation contract.\n', "     * This is a low level function that doesn't return to its internal call site.\n", '     * It will return to the external caller whatever the implementation returns.\n', '     * @param implementation Address to delegate.\n', '     */\n', '    function _delegate(address implementation) internal {\n', '        assembly {\n', '        // Copy msg.data. We take full control of memory in this inline assembly\n', '        // block because it will not return to Solidity code. We overwrite the\n', '        // Solidity scratch pad at memory position 0.\n', '            calldatacopy(0, 0, calldatasize)\n', '\n', '        // Call the implementation.\n', "        // out and outsize are 0 because we don't know the size yet.\n", '            let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)\n', '\n', '        // Copy the returned data.\n', '            returndatacopy(0, 0, returndatasize)\n', '\n', '            switch result\n', '            // delegatecall returns 0 on error.\n', '            case 0 { revert(0, returndatasize) }\n', '            default { return(0, returndatasize) }\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/Passport.sol\n', '\n', '/**\n', ' * @title Passport\n', ' */\n', 'contract Passport is Proxy, ClaimableProxy, DestructibleProxy {\n', '\n', '    event PassportLogicRegistryChanged(\n', '        address indexed previousRegistry,\n', '        address indexed newRegistry\n', '    );\n', '\n', '    /**\n', '     * @dev Storage slot with the address of the current registry of the passport implementations.\n', '     * This is the keccak-256 hash of "org.monetha.passport.proxy.registry", and is\n', '     * validated in the constructor.\n', '     */\n', '    bytes32 private constant REGISTRY_SLOT = 0xa04bab69e45aeb4c94a78ba5bc1be67ef28977c4fdf815a30b829a794eb67a4a;\n', '\n', '    /**\n', '     * @dev Contract constructor.\n', '     * @param _registry Address of the passport implementations registry.\n', '     */\n', '    constructor(IPassportLogicRegistry _registry) public {\n', '        assert(REGISTRY_SLOT == keccak256("org.monetha.passport.proxy.registry"));\n', '\n', '        _setRegistry(_registry);\n', '    }\n', '\n', '    /**\n', '     * @return the address of passport logic registry.\n', '     */\n', '    function getPassportLogicRegistry() public view returns (address) {\n', '        return _getRegistry();\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the current passport logic implementation (used in Proxy fallback function to delegate call\n', '     * to passport logic implementation).\n', '     * @return Address of the current passport implementation\n', '     */\n', '    function _implementation() internal view returns (address) {\n', '        return _getRegistry().getCurrentPassportLogic();\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the current passport implementations registry.\n', '     * @return Address of the current implementation\n', '     */\n', '    function _getRegistry() internal view returns (IPassportLogicRegistry reg) {\n', '        bytes32 slot = REGISTRY_SLOT;\n', '        assembly {\n', '            reg := sload(slot)\n', '        }\n', '    }\n', '\n', '    function _setRegistry(IPassportLogicRegistry _registry) internal {\n', '        require(address(_registry) != 0x0, "Cannot set registry to a zero address");\n', '\n', '        bytes32 slot = REGISTRY_SLOT;\n', '        assembly {\n', '            sstore(slot, _registry)\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/PassportFactory.sol\n', '\n', '/**\n', ' * @title PassportFactory\n', ' * @dev This contract works as a passport factory.\n', ' */\n', 'contract PassportFactory is Ownable, HasNoEther, HasNoTokens {\n', '    IPassportLogicRegistry private registry;\n', '\n', '    /**\n', '    * @dev This event will be emitted every time a new passport is created\n', '    * @param passport representing the address of the passport created\n', '    * @param owner representing the address of the passport owner\n', '    */\n', '    event PassportCreated(address indexed passport, address indexed owner);\n', '\n', '    /**\n', '    * @dev This event will be emitted every time a passport logic registry is changed\n', '    * @param oldRegistry representing the address of the old passport logic registry\n', '    * @param newRegistry representing the address of the new passport logic registry\n', '    */\n', '    event PassportLogicRegistryChanged(address indexed oldRegistry, address indexed newRegistry);\n', '\n', '    constructor(IPassportLogicRegistry _registry) public {\n', '        _setRegistry(_registry);\n', '    }\n', '\n', '    function setRegistry(IPassportLogicRegistry _registry) public onlyOwner {\n', '        emit PassportLogicRegistryChanged(registry, _registry);\n', '        _setRegistry(_registry);\n', '    }\n', '\n', '    function getRegistry() external view returns (address) {\n', '        return registry;\n', '    }\n', '\n', '    /**\n', '    * @dev Creates new passport. The method should be called by the owner of the created passport.\n', '    * After the passport is created, the owner must call the claimOwnership() passport method to become a full owner.\n', '    * @return address of the created passport\n', '    */\n', '    function createPassport() public returns (Passport) {\n', '        Passport pass = new Passport(registry);\n', '        pass.transferOwnership(msg.sender); // owner needs to call claimOwnership()\n', '        emit PassportCreated(pass, msg.sender);\n', '        return pass;\n', '    }\n', '\n', '    function _setRegistry(IPassportLogicRegistry _registry) internal {\n', '        require(address(_registry) != 0x0);\n', '        registry = _registry;\n', '    }\n', '}']