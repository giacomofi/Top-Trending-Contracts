['pragma solidity 0.4.25;\n', '/**\n', '* XYZBuys TOKEN Contract\n', '* ERC-20 Token Standard Compliant\n', '*/\n', '\n', '/**\n', ' * @title SafeMath by OpenZeppelin\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '}\n', '\n', '/**\n', '* @title ERC20 Token minimal interface\n', '*/\n', 'contract token {\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', "    //Since some tokens doesn't return a bool on transfer, this general interface\n", "    //doesn't include a return on the transfer fucntion to be widely compatible\n", '    function transfer(address _to, uint256 _value) public;\n', '\n', '}\n', '\n', '/**\n', ' * Token contract interface for external use\n', ' */\n', 'contract ERC20TokenInterface {\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 value);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '\n', '    }\n', '\n', '\n', '/**\n', '* @title Admin parameters\n', '* @dev Define administration parameters for this contract\n', '*/\n', 'contract admined { //This token contract is administered\n', '    //The master address of the contract is called owner since etherscan\n', '    //uses this name to recognize the owner of the contract\n', '    address public owner; //Master address is public\n', '    mapping(address => uint256) public level; //Admin level\n', '    bool public lockSupply; //Mint and Burn Lock flag\n', '    bool public lockTransfer; //Transfer Lock flag\n', '    address public allowedAddress; //an address that can override lock condition\n', '\n', '    /**\n', '    * @dev Contract constructor\n', '    * define initial administrator\n', '    */\n', '    constructor() public {\n', '        owner = 0xA555C90fAaCa8659F1D8EF64281fECBF3Ea3c9af; //Set initial owner to contract creator\n', '        level[owner] = 2;\n', '        emit Owned(owner);\n', '    }\n', '\n', '   /**\n', '    * @dev Function to set an allowed address\n', '    * @param _to The address to give privileges.\n', '    */\n', '    function setAllowedAddress(address _to) onlyAdmin(2) public {\n', '        allowedAddress = _to;\n', '        emit AllowedSet(_to);\n', '    }\n', '\n', '    modifier onlyAdmin(uint8 _level) { //A modifier to define admin-only functions\n', '        require(msg.sender == owner || level[msg.sender] >= _level);\n', '        _;\n', '    }\n', '\n', '    modifier supplyLock() { //A modifier to lock mint and burn transactions\n', '        require(lockSupply == false);\n', '        _;\n', '    }\n', '\n', '    modifier transferLock() { //A modifier to lock transactions\n', '        require(lockTransfer == false || allowedAddress == msg.sender);\n', '        _;\n', '    }\n', '\n', '   /**\n', '    * @dev Function to set new owner address\n', '    * @param _newOwner The address to transfer administration to\n', '    */\n', '    function transferOwnership(address _newOwner) onlyAdmin(2) public { //owner can be transfered\n', '        require(_newOwner != address(0));\n', '        owner = _newOwner;\n', '        level[_newOwner] = 2;\n', '        emit TransferAdminship(owner);\n', '    }\n', '\n', '    function setAdminLevel(address _target, uint8 _level) onlyAdmin(2) public {\n', '        level[_target] = _level;\n', '        emit AdminLevelSet(_target,_level);\n', '    }\n', '\n', '   /**\n', '    * @dev Function to set mint and burn locks\n', '    * @param _set boolean flag (true | false)\n', '    */\n', '    function setSupplyLock(bool _set) onlyAdmin(2) public { //Only the admin can set a lock on supply\n', '        lockSupply = _set;\n', '        emit SetSupplyLock(_set);\n', '    }\n', '\n', '   /**\n', '    * @dev Function to set transfer lock\n', '    * @param _set boolean flag (true | false)\n', '    */\n', '    function setTransferLock(bool _set) onlyAdmin(2) public { //Only the admin can set a lock on transfers\n', '        lockTransfer = _set;\n', '        emit SetTransferLock(_set);\n', '    }\n', '\n', '    //All admin actions have a log for public review\n', '    event AllowedSet(address _to);\n', '    event SetSupplyLock(bool _set);\n', '    event SetTransferLock(bool _set);\n', '    event TransferAdminship(address newAdminister);\n', '    event Owned(address administer);\n', '    event AdminLevelSet(address _target,uint8 _level);\n', '\n', '}\n', '\n', '/**\n', '* @title Token definition\n', '* @dev Define token paramters including ERC20 ones\n', '*/\n', 'contract ERC20Token is ERC20TokenInterface, admined { //Standard definition of a ERC20Token\n', '    using SafeMath for uint256;\n', '    uint256 public totalSupply;\n', '    mapping (address => uint256) balances; //A mapping of all balances per address\n', '    mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances\n', '    mapping (address => bool) frozen; //A mapping of frozen accounts\n', '\n', '    /**\n', '    * @dev Get the balance of an specified address.\n', '    * @param _owner The address to be query.\n', '    */\n', '    function balanceOf(address _owner) public view returns (uint256 value) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token to a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) transferLock public returns (bool success) {\n', '        require(_to != address(0)); //If you dont want that people destroy token\n', '        require(frozen[msg.sender]==false);\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token from an address to another specified address using allowance\n', '    * @param _from The address where token comes.\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transferFrom(address _from, address _to, uint256 _value) transferLock public returns (bool success) {\n', '        require(_to != address(0)); //If you dont want that people destroy token\n', '        require(frozen[_from]==false);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Assign allowance to an specified address to use the owner balance\n', '    * @param _spender The address to be allowed to spend.\n', '    * @param _value The amount to be allowed.\n', '    */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0)); //exploit mitigation\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Get the allowance of an specified address to use another address balance.\n', '    * @param _owner The address of the owner of the tokens.\n', '    * @param _spender The address of the allowed spender.\n', '    */\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '    * @dev Mint token to an specified address.\n', '    * @param _target The address of the receiver of the tokens.\n', '    * @param _mintedAmount amount to mint.\n', '    */\n', '    function mintToken(address _target, uint256 _mintedAmount) onlyAdmin(2) supplyLock public {\n', '        balances[_target] = SafeMath.add(balances[_target], _mintedAmount);\n', '        totalSupply = SafeMath.add(totalSupply, _mintedAmount);\n', '        emit Transfer(address(0), address(this), _mintedAmount);\n', '        emit Transfer(address(this), _target, _mintedAmount);\n', '    }\n', '\n', '    /**\n', '    * @dev Burn tokens.\n', '    * @param _burnedAmount amount to burn.\n', '    */\n', '    function burnToken(uint256 _burnedAmount) onlyAdmin(2) supplyLock public {\n', '        balances[msg.sender] = SafeMath.sub(balances[msg.sender], _burnedAmount);\n', '        totalSupply = SafeMath.sub(totalSupply, _burnedAmount);\n', '        emit Burned(msg.sender, _burnedAmount);\n', '    }\n', '\n', '    /**\n', '    * @dev Frozen account.\n', '    * @param _target The address to being frozen.\n', '    * @param _flag The status of the frozen\n', '    */\n', '    function setFrozen(address _target,bool _flag) onlyAdmin(2) public {\n', '        frozen[_target]=_flag;\n', '        emit FrozenStatus(_target,_flag);\n', '    }\n', '\n', '\n', '    /**\n', '    * @dev Log Events\n', '    */\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Burned(address indexed _target, uint256 _value);\n', '    event FrozenStatus(address _target,bool _flag);\n', '}\n', '\n', '/**\n', '* @title Asset\n', '* @dev Initial supply creation\n', '*/\n', 'contract Asset is ERC20Token {\n', "    string public name = 'XYZBuys';\n", '    uint8 public decimals = 18;\n', "    string public symbol = 'XYZB';\n", "    string public version = '1';\n", '\n', '    constructor() public {\n', '        totalSupply = 1000000000 * (10**uint256(decimals)); //initial token creation\n', '        balances[owner] = totalSupply;\n', '        emit Transfer(address(0), owner, balances[owner]);\n', '    }\n', '\n', '    /**\n', '    * @notice Function to claim ANY token stuck on contract accidentally\n', '    * In case of claim of stuck tokens please contact contract owners\n', '    */\n', '    function claimTokens(token _address, address _to) onlyAdmin(2) public{\n', '        require(_to != address(0));\n', '        uint256 remainder = _address.balanceOf(address(this)); //Check remainder tokens\n', '        _address.transfer(_to,remainder); //Transfer tokens to creator\n', '    }\n', '\n', '    /**\n', '    *@dev Function to handle callback calls\n', '    */\n', '    function() external {\n', '        revert();\n', '    }\n', '\n', '}']