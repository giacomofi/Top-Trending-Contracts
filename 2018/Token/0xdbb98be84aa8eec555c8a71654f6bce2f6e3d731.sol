['pragma solidity ^0.4.24;  \n', '////////////////////////////////////////////////////////////////////////////////\n', 'library     SafeMath\n', '{\n', '    //--------------------------------------------------------------------------\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) \n', '    {\n', '        if (a == 0)     return 0;\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '    //--------------------------------------------------------------------------\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) \n', '    {\n', '        return a/b;\n', '    }\n', '    //--------------------------------------------------------------------------\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) \n', '    {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '    //--------------------------------------------------------------------------\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) \n', '    {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '////////////////////////////////////////////////////////////////////////////////\n', 'library     StringLib       // (minimal version)\n', '{\n', '    function same(string strA, string strB) internal pure returns(bool)\n', '    {\n', '        return keccak256(abi.encodePacked(strA))==keccak256(abi.encodePacked(strB));        // using abi.encodePacked since solidity v0.4.23\n', '    }\n', '}\n', '////////////////////////////////////////////////////////////////////////////////\n', 'contract    ERC20 \n', '{\n', '    using SafeMath  for uint256;\n', '    using StringLib for string;\n', '\n', '    //----- VARIABLES\n', '\n', '    address public              owner;          // Owner of this contract\n', '    address public              admin;          // The one who is allowed to do changes \n', '\n', '    mapping(address => uint256)                         balances;       // Maintain balance in a mapping\n', '    mapping(address => mapping (address => uint256))    allowances;     // Allowances index-1 = Owner account   index-2 = spender account\n', '\n', '    //------ TOKEN SPECIFICATION\n', '\n', '    string  public  constant    name       = "BQT Official Token";\n', '    string  public  constant    symbol     = "BQT";\n', '    uint256 public  constant    decimals   = 18;      // Handle the coin as FIAT (2 decimals). ETH Handles 18 decimal places\n', '    uint256 public  constant    initSupply = 800000000 * 10**decimals;        // 10**18 max\n', '    uint256 public  constant    supplyReserveVal = 600000000 * 10**decimals;          // if quantity => the ##MACRO## addrs "* 10**decimals" \n', '\n', '    //-----\n', '\n', '    uint256 public              totalSupply;\n', '    uint256 public              icoSalesSupply   = 0;                   // Needed when burning tokens\n', '    uint256 public              icoReserveSupply = 0;\n', '    uint256 public              softCap = 10000000   * 10**decimals;\n', '    uint256 public              hardCap = 500000000   * 10**decimals;\n', '\n', '    //---------------------------------------------------- smartcontract control\n', '\n', '    uint256 public              icoDeadLine = 1544313600;     // 2018-12-09 00:00 (GMT+0)\n', '\n', '    bool    public              isIcoPaused            = false; \n', '    bool    public              isStoppingIcoOnHardCap = false;\n', '\n', '    //--------------------------------------------------------------------------\n', '\n', '    modifier duringIcoOnlyTheOwner()  // if not during the ico : everyone is allowed at anytime\n', '    { \n', '        require( now>icoDeadLine || msg.sender==owner );\n', '        _;\n', '    }\n', '\n', '    modifier icoFinished()          { require(now > icoDeadLine);           _; }\n', '    modifier icoNotFinished()       { require(now <= icoDeadLine);          _; }\n', '    modifier icoNotPaused()         { require(isIcoPaused==false);          _; }\n', '    modifier icoPaused()            { require(isIcoPaused==true);           _; }\n', '    modifier onlyOwner()            { require(msg.sender==owner);           _; }\n', '    modifier onlyAdmin()            { require(msg.sender==admin);           _; }\n', '\n', '    //----- EVENTS\n', '\n', '    event Transfer(address indexed fromAddr, address indexed toAddr,   uint256 amount);\n', '    event Approval(address indexed _owner,   address indexed _spender, uint256 amount);\n', '\n', '            //---- extra EVENTS\n', '\n', '    event onAdminUserChanged(   address oldAdmin,       address newAdmin);\n', '    event onOwnershipTransfered(address oldOwner,       address newOwner);\n', '    event onAdminUserChange(    address oldAdmin,       address newAdmin);\n', '    event onIcoDeadlineChanged( uint256 oldIcoDeadLine, uint256 newIcoDeadline);\n', '    event onHardcapChanged(     uint256 hardCap,        uint256 newHardCap);\n', '    event icoIsNowPaused(       uint8 newPauseStatus);\n', '    event icoHasRestarted(      uint8 newPauseStatus);\n', '\n', '    //--------------------------------------------------------------------------\n', '    //--------------------------------------------------------------------------\n', '    constructor()   public \n', '    {\n', '        owner       = msg.sender;\n', '        admin       = owner;\n', '\n', '        isIcoPaused = false;\n', '        //-----\n', '\n', '        balances[owner] = initSupply;   // send the tokens to the owner\n', '        totalSupply     = initSupply;\n', '        icoSalesSupply  = totalSupply;   \n', '\n', '        //----- Handling if there is a special maximum amount of tokens to spend during the ICO or not\n', '\n', '        icoSalesSupply   = totalSupply.sub(supplyReserveVal);\n', '        icoReserveSupply = totalSupply.sub(icoSalesSupply);\n', '    }\n', '    //--------------------------------------------------------------------------\n', '    //--------------------------------------------------------------------------\n', '    //----- ERC20 FUNCTIONS\n', '    //--------------------------------------------------------------------------\n', '    //--------------------------------------------------------------------------\n', '    function balanceOf(address walletAddress) public constant returns (uint256 balance) \n', '    {\n', '        return balances[walletAddress];\n', '    }\n', '    //--------------------------------------------------------------------------\n', '    function transfer(address toAddr, uint256 amountInWei)  public   duringIcoOnlyTheOwner   returns (bool)     // don&#39;t icoNotPaused here. It&#39;s a logic issue. \n', '    {\n', '        require(toAddr!=0x0 && toAddr!=msg.sender && amountInWei>0);     // Prevent transfer to 0x0 address and to self, amount must be >0\n', '\n', '        uint256 availableTokens = balances[msg.sender];\n', '\n', '        //----- Checking Token reserve first : if during ICO    \n', '\n', '        if (msg.sender==owner && now <= icoDeadLine)                    // ICO Reserve Supply checking: Don&#39;t touch the RESERVE of tokens when owner is selling\n', '        {\n', '            assert(amountInWei<=availableTokens);\n', '\n', '            uint256 balanceAfterTransfer = availableTokens.sub(amountInWei);      \n', '\n', '            assert(balanceAfterTransfer >= icoReserveSupply);           // We try to sell more than allowed during an ICO\n', '        }\n', '\n', '        //-----\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(amountInWei);\n', '        balances[toAddr]     = balances[toAddr].add(amountInWei);\n', '\n', '        emit Transfer(msg.sender, toAddr, amountInWei);\n', '\n', '        return true;\n', '    }\n', '    //--------------------------------------------------------------------------\n', '    function allowance(address walletAddress, address spender) public constant returns (uint remaining)\n', '    {\n', '        return allowances[walletAddress][spender];\n', '    }\n', '    //--------------------------------------------------------------------------\n', '    function transferFrom(address fromAddr, address toAddr, uint256 amountInWei)  public  returns (bool) \n', '    {\n', '        if (amountInWei <= 0)                                   return false;\n', '        if (allowances[fromAddr][msg.sender] < amountInWei)     return false;\n', '        if (balances[fromAddr] < amountInWei)                   return false;\n', '\n', '        balances[fromAddr]               = balances[fromAddr].sub(amountInWei);\n', '        balances[toAddr]                 = balances[toAddr].add(amountInWei);\n', '        allowances[fromAddr][msg.sender] = allowances[fromAddr][msg.sender].sub(amountInWei);\n', '\n', '        emit Transfer(fromAddr, toAddr, amountInWei);\n', '        return true;\n', '    }\n', '    //--------------------------------------------------------------------------\n', '    function approve(address spender, uint256 amountInWei) public returns (bool) \n', '    {\n', '        require((amountInWei == 0) || (allowances[msg.sender][spender] == 0));\n', '        allowances[msg.sender][spender] = amountInWei;\n', '        emit Approval(msg.sender, spender, amountInWei);\n', '\n', '        return true;\n', '    }\n', '    //--------------------------------------------------------------------------\n', '    function() public                       \n', '    {\n', '        assert(true == false);      // If Ether is sent to this address, don&#39;t handle it -> send it back.\n', '    }\n', '    //--------------------------------------------------------------------------\n', '    //--------------------------------------------------------------------------\n', '    //--------------------------------------------------------------------------\n', '    function transferOwnership(address newOwner) public onlyOwner               // @param newOwner The address to transfer ownership to.\n', '    {\n', '        require(newOwner != address(0));\n', '\n', '        emit onOwnershipTransfered(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '    //--------------------------------------------------------------------------\n', '    //--------------------------------------------------------------------------\n', '    //--------------------------------------------------------------------------\n', '    //--------------------------------------------------------------------------\n', '    function    changeAdminUser(address newAdminAddress) public onlyOwner\n', '    {\n', '        require(newAdminAddress!=0x0);\n', '\n', '        emit onAdminUserChange(admin, newAdminAddress);\n', '        admin = newAdminAddress;\n', '    }\n', '    //--------------------------------------------------------------------------\n', '    //--------------------------------------------------------------------------\n', '    function    changeIcoDeadLine(uint256 newIcoDeadline) public onlyAdmin\n', '    {\n', '        require(newIcoDeadline!=0);\n', '\n', '        emit onIcoDeadlineChanged(icoDeadLine, newIcoDeadline);\n', '        icoDeadLine = newIcoDeadline;\n', '    }\n', '    //--------------------------------------------------------------------------\n', '    //--------------------------------------------------------------------------\n', '    //--------------------------------------------------------------------------\n', '    function    changeHardCap(uint256 newHardCap) public onlyAdmin\n', '    {\n', '        require(newHardCap!=0);\n', '\n', '        emit onHardcapChanged(hardCap, newHardCap);\n', '        hardCap = newHardCap;\n', '    }\n', '    //--------------------------------------------------------------------------\n', '    function    isHardcapReached()  public view returns(bool)\n', '    {\n', '        return (isStoppingIcoOnHardCap && initSupply-balances[owner] > hardCap);\n', '    }\n', '    //--------------------------------------------------------------------------\n', '    //--------------------------------------------------------------------------\n', '    //--------------------------------------------------------------------------\n', '    function    pauseICO()  public onlyAdmin\n', '    {\n', '        isIcoPaused = true;\n', '        emit icoIsNowPaused(1);\n', '    }\n', '    //--------------------------------------------------------------------------\n', '    function    unpauseICO()  public onlyAdmin\n', '    {\n', '        isIcoPaused = false;\n', '        emit icoHasRestarted(0);\n', '    }\n', '    //--------------------------------------------------------------------------\n', '    function    isPausedICO() public view     returns(bool)\n', '    {\n', '        return (isIcoPaused) ? true : false;\n', '    }\n', '    /*--------------------------------------------------------------------------\n', '    //\n', '    // When ICO is closed, send the remaining (unsold) tokens to address 0x0\n', '    // So no one will be able to use it anymore... \n', '    // Anyone can check address 0x0, so to proove unsold tokens belong to no one anymore\n', '    //\n', '    //--------------------------------------------------------------------------*/\n', '    function destroyRemainingTokens() public onlyAdmin icoFinished icoNotPaused  returns(uint)\n', '    {\n', '        require(msg.sender==owner && now>icoDeadLine);\n', '\n', '        address   toAddr = 0x0000000000000000000000000000000000000000;\n', '\n', '        uint256   amountToBurn = balances[owner];\n', '\n', '        if (amountToBurn > icoReserveSupply)\n', '        {\n', '            amountToBurn = amountToBurn.sub(icoReserveSupply);\n', '        }\n', '\n', '        balances[owner]  = balances[owner].sub(amountToBurn);\n', '        balances[toAddr] = balances[toAddr].add(amountToBurn);\n', '\n', '        emit Transfer(msg.sender, toAddr, amountToBurn);\n', '        //Transfer(msg.sender, toAddr, amountToBurn);\n', '\n', '        return 1;\n', '    }        \n', '\n', '    //--------------------------------------------------------------------------\n', '    //--------------------------------------------------------------------------\n', '\n', '}\n', '////////////////////////////////////////////////////////////////////////////////\n', 'contract    Token  is  ERC20\n', '{\n', '    using SafeMath  for uint256;\n', '    using StringLib for string;\n', '\n', '    //-------------------------------------------------------------------------- Constructor\n', '    constructor()   public \n', '    {\n', '    }\n', '    //--------------------------------------------------------------------------\n', '    //--------------------------------------------------------------------------\n', '    //--------------------------------------------------------------------------\n', '}']