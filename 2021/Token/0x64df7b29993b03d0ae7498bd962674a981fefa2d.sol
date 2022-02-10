['pragma solidity ^0.4.0;\n', '\n', '\n', 'import "./SafeMath.sol";\n', '\n', 'contract MFXCore {\n', '\n', '    /**\n', '     * MATH\n', '     */\n', '\n', '    using SafeMath for uint256;\n', '\n', '    /**\n', '     * DATA\n', '     */\n', '\n', '    // INITIALIZATION DATA\n', '    bool private initialized = false;\n', '\n', '    // ERC20 BASIC DATA\n', '    mapping(address => uint256) internal balances;\n', '    uint256 internal totalSupply_;\n', '    string public constant name = "MFX TOKEN"; // solium-disable-line uppercase\n', '    string public constant symbol = "MFX"; // solium-disable-line uppercase\n', '    uint8 public constant decimals = 5; // solium-disable-line uppercase\n', '\n', '    // ERC20 DATA\n', '    mapping (address => mapping (address => uint256)) internal _allowed;\n', '\n', '    // OWNER DATA\n', '    address public owner;\n', '\n', '    // PAUSABILITY DATA\n', '    bool public paused = false;\n', '\n', '    // LAW ENFORCEMENT DATA\n', '    address public lawEnforcementRole;\n', '    mapping(address => bool) internal frozen;\n', '\n', '    // SUPPLY CONTROL DATA\n', '\n', '\n', '\n', '    address public supplyController;\n', '\n', '    /**\n', '     * EVENTS\n', '     */\n', '\n', '    // ERC20 BASIC EVENTS\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    // ERC20 EVENTS\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    );\n', '\n', '    // OWNABLE EVENTS\n', '    event OwnershipTransferred(\n', '        address indexed oldOwner,\n', '        address indexed newOwner\n', '    );\n', '\n', '    // PAUSABLE EVENTS\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    // LAW ENFORCEMENT EVENTS\n', '    event AddressFrozen(address indexed addr);\n', '    event AddressUnfrozen(address indexed addr);\n', '    event FrozenAddressWiped(address indexed addr);\n', '    event LawEnforcementRoleSet (\n', '        address indexed oldLawEnforcementRole,\n', '        address indexed newLawEnforcementRole\n', '    );\n', '\n', '    // SUPPLY CONTROL EVENTS\n', '    event SupplyIncreased(address indexed to, uint256 value);\n', '    event SupplyDecreased(address indexed from, uint256 value);\n', '    event SupplyControllerSet(\n', '        address indexed oldSupplyController,\n', '        address indexed newSupplyController\n', '    );\n', '\n', '    /**\n', '     * FUNCTIONALITY\n', '     */\n', '\n', '    // INITIALIZATION FUNCTIONALITY\n', '\n', '    /**\n', '     * @dev sets 0 initials tokens, the owner, and the supplyController.\n', '     * this serves as the constructor for the proxy but compiles to the\n', '     * memory model of the Implementation contract.\n', '     */\n', '    function initialize() public {\n', '        require(!initialized, "already initialized");\n', '        owner = msg.sender;\n', '        lawEnforcementRole = address(0);\n', '        totalSupply_ = 0;\n', '        supplyController = msg.sender;\n', '        initialized = true;\n', '    }\n', '\n', '    /**\n', '     * The constructor is used here to ensure that the implementation\n', '     * contract is initialized. An uncontrolled implementation\n', '     * contract might lead to misleading state\n', '     * for users who accidentally interact with it.\n', '     */\n', '    constructor() public {\n', '        initialize();\n', '        pause();\n', '    }\n', '\n', '    // ERC20 BASIC FUNCTIONALITY\n', '\n', '    /**\n', '    * @dev Total number of tokens in existence\n', '    */\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        require(_to != address(0), "cannot transfer to address zero");\n', '        require(!frozen[_to] && !frozen[msg.sender], "address frozen");\n', '        require(_value <= balances[msg.sender], "insufficient funds");\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _addr The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _addr) public view returns (uint256) {\n', '        return balances[_addr];\n', '    }\n', '\n', '    // ERC20 FUNCTIONALITY\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from,address _to,uint256 _value) public whenNotPaused returns (bool)\n', '    {\n', '        require(_to != address(0), "cannot transfer to address zero");\n', '        require(!frozen[_to] && !frozen[_from] && !frozen[msg.sender], "address frozen");\n', '        require(_value <= balances[_from], "insufficient funds");\n', '        require(_value <= _allowed[_from][msg.sender], "insufficient allowance");\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '   /**\n', '    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '    * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    * @param spender The address which will spend the funds.\n', '    * @param value The amount of tokens to be spent.\n', '    */\n', '    function approve(address spender, uint256 value) public whenNotPaused returns (bool) {\n', '        _approve(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '    /**\n', "     * @dev Approve an address to spend another addresses' tokens.\n", '     * @param _owner The address that owns the tokens.\n', '     * @param spender The address that will spend the tokens.\n', '     * @param value The number of tokens that can be spent.\n', '     */\n', '     function _approve(address _owner, address spender, uint256 value) internal {\n', '         require(!frozen[spender] && !frozen[_owner], "address frozen");\n', '         require(spender != address(0) && _owner != address(0),"not address(0)");\n', '         _allowed[_owner][spender] = value;\n', '         emit Approval(_owner, spender, value);\n', '     }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address _owner, address spender) public view returns (uint256) {\n', '        return _allowed[_owner][spender];\n', '    }\n', '\n', '     /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when _allowed[msg.sender][spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * Emits an Approval event.\n', '     * @param spender The address which will spend the funds.\n', '     * @param addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {\n', '        _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when _allowed[msg.sender][spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * Emits an Approval event.\n', '     * @param spender The address which will spend the funds.\n', '     * @param subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {\n', '        _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));\n', '        return true;\n', '    }\n', '\n', '    // OWNER FUNCTIONALITY\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner, "onlyOwner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param _newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        require(_newOwner != address(0), "cannot transfer ownership to address zero");\n', '        emit OwnershipTransferred(owner, _newOwner);\n', '        owner = _newOwner;\n', '    }\n', '\n', '    // PAUSABILITY FUNCTIONALITY\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!paused, "whenNotPaused");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to pause, triggers stopped state\n', '     */\n', '    function pause() public onlyOwner {\n', '        require(!paused, "already paused");\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to unpause, returns to normal state\n', '     */\n', '    function unpause() public onlyOwner {\n', '        require(paused, "already unpaused");\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '\n', '    // LAW ENFORCEMENT FUNCTIONALITY\n', '\n', '    /**\n', '     * @dev Sets a new law enforcement role address.\n', '     * @param _newLawEnforcementRole The new address allowed to freeze/unfreeze addresses and seize their tokens.\n', '     */\n', '    function setLawEnforcementRole(address _newLawEnforcementRole) public {\n', '        require(_newLawEnforcementRole != address(0),"lawEnforcementRole cannot address(0)");\n', '        require(msg.sender == lawEnforcementRole || msg.sender == owner, "only lawEnforcementRole or Owner");\n', '        emit LawEnforcementRoleSet(lawEnforcementRole, _newLawEnforcementRole);\n', '        lawEnforcementRole = _newLawEnforcementRole;\n', '    }\n', '\n', '    modifier onlyLawEnforcementRole() {\n', '        require(msg.sender == lawEnforcementRole, "onlyLawEnforcementRole");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Freezes an address balance from being transferred.\n', '     * @param _addr The new address to freeze.\n', '     */\n', '    function freeze(address _addr) public onlyLawEnforcementRole {\n', '        require(!frozen[_addr], "address already frozen");\n', '        frozen[_addr] = true;\n', '        emit AddressFrozen(_addr);\n', '    }\n', '\n', '    /**\n', '     * @dev Unfreezes an address balance allowing transfer.\n', '     * @param _addr The new address to unfreeze.\n', '     */\n', '    function unfreeze(address _addr) public onlyLawEnforcementRole {\n', '        require(frozen[_addr], "address already unfrozen");\n', '        frozen[_addr] = false;\n', '        emit AddressUnfrozen(_addr);\n', '    }\n', '\n', '    /**\n', '     * @dev Wipes the balance of a frozen address, burning the tokens\n', '     * @param _addr The new frozen address to wipe.\n', '     */\n', '    function wipeFrozenAddress(address _addr) public onlyLawEnforcementRole {\n', '        require(frozen[_addr], "address is not frozen");\n', '        uint256 _balance = balances[_addr];\n', '        balances[_addr] = 0;\n', '        totalSupply_ = totalSupply_.sub(_balance);\n', '        emit FrozenAddressWiped(_addr);\n', '        emit SupplyDecreased(_addr, _balance);\n', '        emit Transfer(_addr, address(0), _balance);\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _addr The address to check if frozen.\n', '    * @return A bool representing whether the given address is frozen.\n', '    */\n', '    function isFrozen(address _addr) public view returns (bool) {\n', '        return frozen[_addr];\n', '    }\n', '\n', '    // SUPPLY CONTROL FUNCTIONALITY\n', '\n', '    /**\n', '     * @dev Sets a new supply controller address.\n', '     * @param _newSupplyController The address allowed to burn/mint tokens to control supply.\n', '     */\n', '    function setSupplyController(address _newSupplyController) public {\n', '        require(msg.sender == supplyController || msg.sender == owner, "only SupplyController or Owner");\n', '        require(_newSupplyController != address(0), "cannot set supply controller to address zero");\n', '        emit SupplyControllerSet(supplyController, _newSupplyController);\n', '        supplyController = _newSupplyController;\n', '    }\n', '\n', '    modifier onlySupplyController() {\n', '        require(msg.sender == supplyController, "onlySupplyController");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Increases the total supply by minting the specified number of tokens to the supply controller account.\n', '     * @param _value The number of tokens to add.\n', '     * @return A boolean that indicates if the operation was successful.\n', '     */\n', '    function increaseSupply(uint256 _value) public onlySupplyController returns (bool success) {\n', '        totalSupply_ = totalSupply_.add(_value);\n', '        balances[supplyController] = balances[supplyController].add(_value);\n', '        emit SupplyIncreased(supplyController, _value);\n', '        emit Transfer(address(0), supplyController, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decreases the total supply by burning the specified number of tokens from the supply controller account.\n', '     * @param _value The number of tokens to remove.\n', '     * @return A boolean that indicates if the operation was successful.\n', '     */\n', '    function decreaseSupply(uint256 _value) public onlySupplyController returns (bool success) {\n', '        require(_value <= balances[supplyController], "not enough supply");\n', '        balances[supplyController] = balances[supplyController].sub(_value);\n', '        totalSupply_ = totalSupply_.sub(_value);\n', '        emit SupplyDecreased(supplyController, _value);\n', '        emit Transfer(supplyController, address(0), _value);\n', '        return true;\n', '    }\n', '}']