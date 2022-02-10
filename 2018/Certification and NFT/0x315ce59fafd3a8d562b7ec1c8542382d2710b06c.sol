['pragma solidity 0.4.19;\n', '/**\n', '* @title Cacao Shares TOKEN\n', '* @dev ERC-20 Token Standard Compliant\n', '* @notice Contact ico@cacaoshares.com\n', '* @author Fares A. Akel C.\n', '* ================================================\n', '* CACAO SHARES IS A DIGITAL ASSET\n', '* THAT ENABLES ANYONE TO OWN CACAO TREES\n', '* OF THE CRIOLLO TYPE IN SUR DEL LAGO, VENEZUELA\n', '* ================================================\n', '*/\n', '\n', '/**\n', ' * @title SafeMath by OpenZeppelin (partially)\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '}\n', '/**\n', ' * Token contract interface for external use\n', ' */\n', 'contract ERC20TokenInterface {\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 value);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '\n', '    }\n', '\n', '\n', '/**\n', '* @title Admin parameters\n', '* @dev Define administration parameters for this contract\n', '*/\n', 'contract admined { //This token contract is administered\n', '    address public admin; //Admin address is public\n', '    bool public lockTransfer; //Transfer Lock flag\n', '    address public allowedAddress; //an address that can override lock condition\n', '\n', '    /**\n', '    * @dev Contract constructor\n', '    * define initial administrator\n', '    */\n', '    function admined() internal {\n', '        admin = msg.sender; //Set initial admin to contract creator\n', '        allowedAddress = msg.sender; //Set initial allowed to contract creator\n', '        Admined(admin);\n', '        AllowedSet(allowedAddress);\n', '    }\n', '\n', '    modifier onlyAdmin() { //A modifier to define admin-only functions\n', '        require(msg.sender == admin);\n', '        _;\n', '    }\n', '\n', '    modifier transferLock() { //A modifier to lock transactions\n', '        require(lockTransfer == false || allowedAddress == msg.sender);\n', '        _;\n', '    }\n', '\n', '   /**\n', '    * @dev Function to set an allowed address\n', '    * @param _to The address to give privileges.\n', '    */\n', '    function setAllowedAddress(address _to) onlyAdmin public {\n', '        allowedAddress = _to;\n', '        AllowedSet(_to);\n', '    }\n', '\n', '   /**\n', '    * @dev Function to set new admin address\n', '    * @param _newAdmin The address to transfer administration to\n', '    */\n', '    function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered\n', '        require(_newAdmin != address(0)); //Prevent zero address transactions\n', '        admin = _newAdmin;\n', '        TransferAdminship(admin);\n', '    }\n', '\n', '   /**\n', '    * @dev Function to unlock transfers\n', "    * @notice It's only possible to unlock the transfers\n", '    */\n', '    function setTransferLockFree() onlyAdmin public {\n', "        require(lockTransfer == true);// only if it's locked\n", '        lockTransfer = false;\n', '        SetTransferLock(lockTransfer);\n', '    }\n', '\n', '    //All admin actions have a log for public review\n', '    event AllowedSet(address _to);\n', '    event SetTransferLock(bool _set);\n', '    event TransferAdminship(address newAdminister);\n', '    event Admined(address administer);\n', '\n', '}\n', '\n', '/**\n', '* @title Token definition\n', '* @dev Define token parameters including ERC20 ones\n', '*/\n', 'contract ERC20Token is ERC20TokenInterface, admined { //Standard definition of a ERC20Token\n', '    using SafeMath for uint256;\n', '    uint256 public totalSupply;\n', '    mapping (address => uint256) balances; //A mapping of all balances per address\n', '    mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances\n', '\n', '    /**\n', '    * @dev Get the balance of an specified address.\n', '    * @param _owner The address to be query.\n', '    */\n', '    function balanceOf(address _owner) public constant returns (uint256 value) {\n', '      return balances[_owner];\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token to a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) transferLock public returns (bool success) {\n', '        require(_to != address(0)); //Prevent zero address transactions\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token from an address to another specified address using allowance\n', '    * @param _from The address where token comes.\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transferFrom(address _from, address _to, uint256 _value) transferLock public returns (bool success) {\n', '        require(_to != address(0)); //Prevent zero address transactions\n', '        balances[_from] = balances[_from].sub(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Assign allowance to an specified address to use the owner balance\n', '    * @param _spender The address to be allowed to spend.\n', '    * @param _value The amount to be allowed.\n', '    */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        require(_value == 0 || allowed[msg.sender][_spender] == 0); //Mitigation to possible attack on approve and transferFrom functions\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Get the allowance of an specified address to use another address balance.\n', '    * @param _owner The address of the owner of the tokens.\n', '    * @param _spender The address of the allowed spender.\n', '    */\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '    * @dev Log Events\n', '    */\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '/**\n', '* @title AssetCCS\n', '* @dev Initial CCS supply creation\n', '*/\n', 'contract AssetCCS is ERC20Token {\n', '    \n', "    string public name = 'Cacao Shares';\n", '    uint8 public decimals = 18;\n', "    string public symbol = 'CCS';\n", "    string public version = '1';\n", '\n', '    function AssetCCS() public {\n', '        \n', '        totalSupply = 100000000 * (10**uint256(decimals)); //100 million total token creation\n', '        balances[msg.sender] = totalSupply;\n', '\n', '        /**\n', '        * This token is locked for transfers until the 90th day after ICO ending,\n', '        * the measure is globally applied, the only address able to transfer is the single\n', '        * allowed address. During ICO period, allowed address will be ICO address.\n', '        */\n', '        lockTransfer = true;\n', '        SetTransferLock(lockTransfer);\n', '\n', '        Transfer(0, this, totalSupply);\n', '        Transfer(this, msg.sender, balances[msg.sender]);\n', '    \n', '    }\n', '    \n', '    /**\n', '    *@dev Function to handle callback calls\n', '    */\n', '    function() public {\n', '        revert();\n', '    }\n', '}']