['// File: @openzeppelin/contracts/token/ERC20/IERC20.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP. Does not include\n', ' * the optional functions; to access them see {ERC20Detailed}.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: contracts/Storage.sol\n', '\n', 'pragma solidity 0.5.16;\n', '\n', 'contract Storage {\n', '\n', '  address public governance;\n', '  address public controller;\n', '\n', '  constructor() public {\n', '    governance = msg.sender;\n', '  }\n', '\n', '  modifier onlyGovernance() {\n', '    require(isGovernance(msg.sender), "Not governance");\n', '    _;\n', '  }\n', '\n', '  function setGovernance(address _governance) public onlyGovernance {\n', '    require(_governance != address(0), "new governance shouldn\'t be empty");\n', '    governance = _governance;\n', '  }\n', '\n', '  function setController(address _controller) public onlyGovernance {\n', '    require(_controller != address(0), "new controller shouldn\'t be empty");\n', '    controller = _controller;\n', '  }\n', '\n', '  function isGovernance(address account) public view returns (bool) {\n', '    return account == governance;\n', '  }\n', '\n', '  function isController(address account) public view returns (bool) {\n', '    return account == controller;\n', '  }\n', '}\n', '\n', '// File: contracts/Governable.sol\n', '\n', 'pragma solidity 0.5.16;\n', '\n', '\n', 'contract Governable {\n', '\n', '  Storage public store;\n', '\n', '  constructor(address _store) public {\n', '    require(_store != address(0), "new storage shouldn\'t be empty");\n', '    store = Storage(_store);\n', '  }\n', '\n', '  modifier onlyGovernance() {\n', '    require(store.isGovernance(msg.sender), "Not governance");\n', '    _;\n', '  }\n', '\n', '  function setStorage(address _store) public onlyGovernance {\n', '    require(_store != address(0), "new storage shouldn\'t be empty");\n', '    store = Storage(_store);\n', '  }\n', '\n', '  function governance() public view returns (address) {\n', '    return store.governance();\n', '  }\n', '}\n', '\n', '// File: contracts/Controllable.sol\n', '\n', 'pragma solidity 0.5.16;\n', '\n', '\n', 'contract Controllable is Governable {\n', '\n', '  constructor(address _storage) Governable(_storage) public {\n', '  }\n', '\n', '  modifier onlyController() {\n', '    require(store.isController(msg.sender), "Not a controller");\n', '    _;\n', '  }\n', '\n', '  modifier onlyControllerOrGovernance(){\n', '    require((store.isController(msg.sender) || store.isGovernance(msg.sender)),\n', '      "The caller must be controller or governance");\n', '    _;\n', '  }\n', '\n', '  function controller() public view returns (address) {\n', '    return store.controller();\n', '  }\n', '}\n', '\n', '// File: contracts/hardworkInterface/IController.sol\n', '\n', 'pragma solidity 0.5.16;\n', '\n', 'interface IController {\n', '    // [Grey list]\n', '    // An EOA can safely interact with the system no matter what.\n', "    // If you're using Metamask, you're using an EOA.\n", '    // Only smart contracts may be affected by this grey list.\n', '    //\n', '    // This contract will not be able to ban any EOA from the system\n', '    // even if an EOA is being added to the greyList, he/she will still be able\n', '    // to interact with the whole system as if nothing happened.\n', '    // Only smart contracts will be affected by being added to the greyList.\n', '    // This grey list is only used in Vault.sol, see the code there for reference\n', '    function greyList(address _target) external view returns(bool);\n', '\n', '    function addVaultAndStrategy(address _vault, address _strategy) external;\n', '    function doHardWork(address _vault) external;\n', '    function hasVault(address _vault) external returns(bool);\n', '\n', '    function salvage(address _token, uint256 amount) external;\n', '    function salvageStrategy(address _strategy, address _token, uint256 amount) external;\n', '\n', '    function notifyFee(address _underlying, uint256 fee) external;\n', '    function profitSharingNumerator() external view returns (uint256);\n', '    function profitSharingDenominator() external view returns (uint256);\n', '}\n', '\n', '// File: contracts/HardWorkHelper.sol\n', '\n', 'pragma solidity 0.5.16;\n', '\n', '\n', '\n', '\n', 'contract HardWorkHelper is Controllable {\n', '\n', '  address[] public vaults;\n', '  IERC20 public farmToken;\n', '\n', '  constructor(address _storage, address _farmToken)\n', '  Controllable(_storage) public {\n', '    farmToken = IERC20(_farmToken);\n', '  }\n', '\n', '  /**\n', '  * Initializes the vaults and order of calls\n', '  */\n', '  function setVaults(address[] memory newVaults) public onlyGovernance {\n', '    if (getNumberOfVaults() > 0) {\n', '      for (uint256 i = vaults.length - 1; i >= 0 ; i--) {\n', '        delete vaults[i];\n', '      }\n', '    }\n', '    vaults.length = 0;\n', '    for (uint256 i = 0; i < newVaults.length; i++) {\n', '      vaults.push(newVaults[i]);\n', '    }\n', '  }\n', '\n', '  function getNumberOfVaults() public view returns(uint256) {\n', '    return vaults.length;\n', '  }\n', '\n', '  /**\n', '  * Does the hard work for all the pools. Cannot be called by smart contracts in order to avoid\n', '  * a possible flash loan liquidation attack.\n', '  */\n', '  function doHardWork() public {\n', '    require(msg.sender == tx.origin, "Smart contracts cannot work hard");\n', '    for (uint256 i = 0; i < vaults.length; i++) {\n', '      IController(controller()).doHardWork(vaults[i]);\n', '    }\n', '    // transfer the reward to the caller\n', '    uint256 balance = farmToken.balanceOf(address(this));\n', '    farmToken.transfer(msg.sender, balance);\n', '  }\n', '}']