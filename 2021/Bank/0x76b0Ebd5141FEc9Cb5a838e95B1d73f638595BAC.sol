['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-01\n', '*/\n', '\n', 'pragma solidity 0.5.17;   /*\n', '\n', '\n', '\n', '    ___________________________________________________________________\n', '      _      _                                        ______           \n', '      |  |  /          /                                /              \n', '    --|-/|-/-----__---/----__----__---_--_----__-------/-------__------\n', "      |/ |/    /___) /   /   ' /   ) / /  ) /___)     /      /   )     \n", '    __/__|____(___ _/___(___ _(___/_/_/__/_(___ _____/______(___/__o_o_\n', '\n', '\n', '    \n', '███████╗███╗░░░███╗░█████╗░██████╗░██╗░░██╗███████╗████████╗\u2003\u2003██████╗░███████╗██╗░░██╗\n', '██╔════╝████╗░████║██╔══██╗██╔══██╗██║░██╔╝██╔════╝╚══██╔══╝\u2003\u2003██╔══██╗██╔════╝╚██╗██╔╝\n', '█████╗░░██╔████╔██║███████║██████╔╝█████═╝░█████╗░░░░░██║░░░\u2003\u2003██║░░██║█████╗░░░╚███╔╝░\n', '██╔══╝░░██║╚██╔╝██║██╔══██║██╔══██╗██╔═██╗░██╔══╝░░░░░██║░░░\u2003\u2003██║░░██║██╔══╝░░░██╔██╗░\n', '███████╗██║░╚═╝░██║██║░░██║██║░░██║██║░╚██╗███████╗░░░██║░░░\u2003\u2003██████╔╝███████╗██╔╝╚██╗\n', '╚══════╝╚═╝░░░░░╚═╝╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚═╝╚══════╝░░░╚═╝░░░\u2003\u2003╚═════╝░╚══════╝╚═╝░░╚═╝\n', '\n', ' \n', '*/\n', '\n', '\n', '//*******************************************************************\n', '//------------------------ SafeMath Library -------------------------\n', '//*******************************************************************\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, "SafeMath: division by zero");\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '}\n', '\n', '//*******************************************************************//\n', '//------------------ Contract to Manage Ownership -------------------//\n', '//*******************************************************************//\n', '    \n', 'contract owned {\n', '    address payable public owner;\n', '    address payable public newOwner;\n', '\n', '\n', '    event OwnershipTransferred(uint256 curTime, address indexed _from, address indexed _to);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function onlyOwnerTransferOwnership(address payable _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    //this flow is to prevent transferring ownership to wrong wallet by mistake\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(now, owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', 'interface ERC20Essential \n', '{\n', '\n', '    function transfer(address _to, uint256 _amount) external returns (bool);\n', '    function transferFrom(address _from, address _to, uint256 _amount) external returns (bool);\n', '}\n', '\n', 'interface ERC865Essential\n', '{\n', '    function transferPreSigned(address _from, address _to,uint256 _value,uint256 _fee,uint256 _nonce,uint8 v,bytes32 r,bytes32 s) external returns(bool);\n', '    function withdrawPreSigned(address _from, address _to,uint256 _value,uint256 _fee,uint256 _nonce,uint8 v,bytes32 r,bytes32 s) external returns(bool);\n', '}\n', '\n', 'contract eMarketDex is owned {\n', '  using SafeMath for uint256;\n', '  bool public safeGuard; // To hault all non owner functions in case of imergency - by default false\n', '  address public admin; //the admin address\n', '  address public feeAccount; //the account that will receive fees\n', '  uint public tradingFee = 50; // 50 = 0.5%\n', '  \n', '  mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)\n', '  mapping (address => mapping (bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)\n', '  mapping (address => mapping (bytes32 => uint)) public orderFills; //mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)\n', '  \n', '  event Order(uint256 curTime, address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);\n', '  event Cancel(uint256 curTime, address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);\n', '  event Trade(uint256 curTime, address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give, uint256 orderBookID);\n', '  event Deposit(uint256 curTime, address token, address user, uint amount, uint balance);\n', '  event Withdraw(uint256 curTime, address token, address user, uint amount, uint balance);\n', '\n', '    event OwnerWithdrawTradingFee(address indexed ownerAddress, uint256 amount);\n', '\n', '    constructor() public {\n', '        feeAccount = msg.sender;\n', '    }\n', '\n', '    //Calculate percent and return result\n', '    function calculatePercentage(uint256 PercentOf, uint256 percentTo ) internal pure returns (uint256) \n', '    {\n', '        uint256 factor = 10000;\n', '        require(percentTo <= factor);\n', '        uint256 c = PercentOf.mul(percentTo).div(factor);\n', '        return c;\n', '    }  \n', '    \n', '  // contract without fallback automatically reject incoming ether\n', '  // function() external {  }\n', '\n', '\n', '  function changeFeeAccount(address feeAccount_) public onlyOwner {\n', '    feeAccount = feeAccount_;\n', '  }\n', '\n', '  function changetradingFee(uint tradingFee_) public onlyOwner{\n', '    //require(tradingFee_ <= tradingFee);\n', '    tradingFee = tradingFee_;\n', '  }\n', '  \n', '  function availableTradingFeeOwner() public view returns(uint256){\n', '      //it only holds ether as fee\n', '      return tokens[address(0)][feeAccount];\n', '  }\n', '  \n', '  function withdrawTradingFeeOwner() public onlyOwner returns (string memory){\n', '      uint256 amount = availableTradingFeeOwner();\n', "      require (amount > 0, 'Nothing to withdraw');\n", '      \n', '      tokens[address(0)][feeAccount] = 0;\n', '      \n', '      msg.sender.transfer(amount);\n', '      \n', '      emit OwnerWithdrawTradingFee(owner, amount);\n', '  }\n', '\n', '  function deposit() public payable {\n', '    tokens[address(0)][msg.sender] = tokens[address(0)][msg.sender].add(msg.value);\n', '    emit Deposit(now, address(0), msg.sender, msg.value, tokens[address(0)][msg.sender]);\n', '  }\n', '\n', '  function withdraw(uint amount) public {\n', '    require(!safeGuard,"System Paused by Admin");\n', '    require(tokens[address(0)][msg.sender] >= amount);\n', '    tokens[address(0)][msg.sender] = tokens[address(0)][msg.sender].sub(amount);\n', '    msg.sender.transfer(amount);\n', '    emit Withdraw(now, address(0), msg.sender, amount, tokens[address(0)][msg.sender]);\n', '  }\n', '\n', '  function depositToken(address token, uint amount) public {\n', '    //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.\n', '    require(token!=address(0));\n', '    require(ERC20Essential(token).transferFrom(msg.sender, address(this), amount));\n', '    tokens[token][msg.sender] = tokens[token][msg.sender].add(amount);\n', '    emit Deposit(now, token, msg.sender, amount, tokens[token][msg.sender]);\n', '  }\n', '\t\n', '  function withdrawToken(address token, uint amount) public {\n', '    require(!safeGuard,"System Paused by Admin");\n', '    require(token!=address(0));\n', '    require(tokens[token][msg.sender] >= amount);\n', '    tokens[token][msg.sender] = tokens[token][msg.sender].sub(amount);\n', '\t  ERC20Essential(token).transfer(msg.sender, amount);\n', '    emit Withdraw(now, token, msg.sender, amount, tokens[token][msg.sender]);\n', '  }\n', '\n', '  function balanceOf(address token, address user) public view returns (uint) {\n', '    return tokens[token][user];\n', '  }\n', '\n', '  function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) public {\n', '    bytes32 hash = keccak256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));\n', '    orders[msg.sender][hash] = true;\n', '    emit Order(now, tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender);\n', '  }\n', '\n', '  function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, uint256 orderBookID) public {\n', '    require(!safeGuard,"System Paused by Admin");\n', '    //amount is in amountGet terms\n', '    bytes32 hash = keccak256(abi.encodePacked(address(this), tokenGet, amountGet, tokenGive, amountGive, expires, nonce));\n', '    require((\n', '      (orders[user][hash] || ecrecover(keccak256(abi.encodePacked("\\x19Ethereum Signed Message:\\n32", hash)),v,r,s) == user) &&\n', '      block.number <= expires &&\n', '      orderFills[user][hash].add(amount) <= amountGet\n', '    ),"Invalid");\n', '    splitTrade(tokenGet, amountGet, tokenGive, amountGive, user, amount, orderBookID);\n', '    orderFills[user][hash] = orderFills[user][hash].add(amount);\n', '  }\n', '  \n', '  function splitTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount, uint256 orderBookID) internal {\n', '      \n', '      tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);\n', '      emit Trade(now, tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, msg.sender, orderBookID);\n', '  }\n', '  \n', '  function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) internal {\n', '    \n', '    uint tradingFeeXfer = calculatePercentage(amount,tradingFee);\n', '\n', '    tokens[tokenGet][msg.sender] = tokens[tokenGet][msg.sender].sub(amount.add(tradingFeeXfer));\n', '    tokens[tokenGet][user] = tokens[tokenGet][user].add(amount.sub(tradingFeeXfer));\n', '    tokens[address(0)][feeAccount] = tokens[address(0)][feeAccount].add(tradingFeeXfer);\n', '\n', '    tokens[tokenGive][user] = tokens[tokenGive][user].sub(amountGive.mul(amount) / amountGet);\n', '    tokens[tokenGive][msg.sender] = tokens[tokenGive][msg.sender].add(amountGive.mul(amount) / amountGet);\n', '  }\n', '\n', '  function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) public view returns(bool) {\n', '    \n', '    if (!(\n', '      tokens[tokenGet][sender] >= amount &&\n', '      availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount\n', '    )) return false;\n', '    return true;\n', '  }\n', '\n', '  function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) public view returns(uint) {\n', '    bytes32 hash = keccak256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));\n', '    uint available1;\n', '    if (!(\n', '      (orders[user][hash] || ecrecover(keccak256(abi.encodePacked("\\x19Ethereum Signed Message:\\n32", hash)),v,r,s) == user) &&\n', '      block.number <= expires\n', '    )) return 0;\n', '    available1 = tokens[tokenGive][user].mul(amountGet) / amountGive;\n', '    \n', '    if (amountGet.sub(orderFills[user][hash])<available1) return amountGet.sub(orderFills[user][hash]);\n', '    return available1;\n', '  }\n', '\n', '  function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user) public view returns(uint) {\n', '    bytes32 hash = keccak256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));\n', '    return orderFills[user][hash];\n', '  }\n', '\n', '  function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) public {\n', '    require(!safeGuard,"System Paused by Admin");\n', '    bytes32 hash = keccak256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));\n', '    require((orders[msg.sender][hash] || ecrecover(keccak256(abi.encodePacked("\\x19Ethereum Signed Message:\\n32", hash)),v,r,s) == msg.sender));\n', '    orderFills[msg.sender][hash] = amountGet;\n', '    emit Cancel(now, tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);\n', '  }\n', '\n', '    /****************************************/\n', '    /* Custom Code for the ERC865 TOKEN */\n', '    /****************************************/\n', '\n', '     /* Nonces of transfers performed */\n', '    mapping(bytes32 => bool) transactionHashes;\n', '    \n', '    function transferFromPreSigned(\n', '        address token,\n', '        address _from,\n', '        address _to,\n', '        uint256 _value,\n', '        uint256 _fee,\n', '        uint256 _nonce,\n', '        uint8 v, \n', '        bytes32 r, \n', '        bytes32 s\n', '    )\n', '        public\n', '        returns (bool)\n', '    {\n', '        require(_to != address(0));\n', "        bytes32 hashedTx = keccak256(abi.encodePacked('transferFromPreSigned', address(this), _from, _to, _value, _fee, _nonce));\n", "        require(transactionHashes[hashedTx] == false, 'transaction hash is already used');\n", '        address spender = ecrecover(keccak256(abi.encodePacked("\\x19Ethereum Signed Message:\\n32", hashedTx)),v,r,s);\n', "        require(spender != address(0), 'Invalid _from address');\n", '        require(ERC20Essential(token).transferFrom(_from, _to, _value),"transferfrom fail");\n', '        require(ERC20Essential(token).transferFrom(spender, msg.sender, _fee),"transfer from fee fail");\n', '        transactionHashes[hashedTx] = true;\n', '        return true;\n', '    }\n', '    \n', '    function transferPreSigned(\n', '        address token,\n', '        address _from,\n', '        address _to,\n', '        uint256 _value,\n', '        uint256 _fee,\n', '        uint256 _nonce,\n', '        uint8 v, \n', '        bytes32 r, \n', '        bytes32 s\n', '    )\n', '        public\n', '        returns (bool)\n', '    {\n', '        require(_to != address(0));\n', "        bytes32 hashedTx = keccak256(abi.encodePacked('transferFromPreSigned', address(this), _to, _value, _fee, _nonce));\n", "        require(transactionHashes[hashedTx] == false, 'transaction hash is already used');\n", '        address spender = ecrecover(keccak256(abi.encodePacked("\\x19Ethereum Signed Message:\\n32", hashedTx)),v,r,s);\n', "        require(spender != address(0), 'Invalid _from address');\n", '        require(_from==spender);\n', '        require(ERC20Essential(token).transfer(_to, _value.sub(_fee)),"transferfrom fail");\n', '        require(ERC20Essential(token).transfer( msg.sender, _fee),"transfer from fee fail");\n', '        transactionHashes[hashedTx] = true;\n', '        return true;\n', '    }\n', '     \n', '    function testSender(\n', '        address _to,\n', '        uint256 _value,\n', '        uint256 _fee,\n', '        uint256 _nonce,\n', '        uint8 v, \n', '        bytes32 r, \n', '        bytes32 s\n', '    )\n', '        public\n', '        view\n', '        returns (address)\n', '    {\n', '        bytes32 hashedTx = keccak256(abi.encodePacked(address(this), _to, _value, _fee, _nonce));\n', '        return ecrecover(keccak256(abi.encodePacked("\\x19Ethereum Signed Message:\\n32", hashedTx)),v,r,s);\n', '    }\n', '\n', '    /********************************/\n', '    /*  Code for helper functions   */\n', '    /********************************/\n', '      \n', '    //Just in case, owner wants to transfer Ether from contract to owner address\n', '    function manualWithdrawEther()onlyOwner public{\n', '        address(owner).transfer(address(this).balance);\n', '    }\n', '    \n', '    //Just in case, owner wants to transfer Tokens from contract to owner address\n', '    //tokenAmount must be in WEI\n', '    function manualWithdrawTokens(address token, uint256 tokenAmount)onlyOwner public{\n', '        ERC20Essential(token).transfer(msg.sender, tokenAmount);\n', '    }\n', '    \n', '    //selfdestruct function. just in case owner decided to destruct this contract.\n', '    function destructContract()onlyOwner public{\n', '        selfdestruct(owner);\n', '    }\n', '    \n', '    /**\n', '     * Change safeguard status on or off\n', '     *\n', '     * When safeguard is true, then all the non-owner functions will stop working.\n', '     * When safeguard is false, then all the functions will resume working back again!\n', '     */\n', '    function changeSafeguardStatus() onlyOwner public{\n', '        if (safeGuard == false){\n', '            safeGuard = true;\n', '        }\n', '        else{\n', '            safeGuard = false;    \n', '        }\n', '    }\n', '\n', '    // function getpreSignHash(string memory _messg, address currentcon, address _to, uint _amount, uint fee, uint _nonce)public view returns (bytes32)\n', '    // {\n', '    //     return keccak256(abi.encodePacked(_messg,currentcon,_to,_amount,fee,_nonce));\n', '    // }\n', '    \n', '    // function transferfromPresignedhash(string memory _messg,address _from, address currentcon, address _to, uint _amount, uint fee, uint _nonce)public view returns (bytes32)\n', '    // {\n', '    //     return keccak256(abi.encodePacked(_messg,currentcon,_from, _to,_amount,fee,_nonce));\n', '    // }\n', '    \n', '    // function getpreSignTradeHash(address tokenGet,uint amountGet,address tokenGive,uint amountGive,uint expires,uint nonce, address _from)public view returns (bytes32)\n', '    // {\n', '    //     return keccak256(abi.encodePacked(_from, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));\n', '    // }\n', '    \n', '    function preSignDeposit(address token, uint amount,uint8 v,bytes32 r,bytes32 s, address _from, uint _fee,uint _nonce) public {\n', '        \n', '        require(token!=address(0));\n', '        require(ERC865Essential(token).transferPreSigned(_from, address(this), amount, _fee, _nonce, v, r, s));\n', '        //require(ERC20Essential(token).transfer(msg.sender, _fee));\n', '        tokens[token][_from] = tokens[token][_from].add(amount).sub(_fee);\n', '        emit Deposit(now, token, _from, amount, tokens[token][_from]);\n', '      }\n', '      \n', '      function preSignWithdraw(address token,address _to, uint amount,uint fee,uint8 v,bytes32 r,bytes32 s,uint _nonce ) public  returns(bool){\n', '        \n', '        require(!safeGuard,"System Paused by Admin");\n', '        require(token!=address(0));\n', '        require(tokens[token][_to] >= amount);\n', '    \trequire(ERC865Essential(token).withdrawPreSigned(address(this),_to, amount, fee, _nonce, v, r, s));\n', '    \ttokens[token][_to] = tokens[token][_to].sub(amount).sub(fee);\n', '        emit Withdraw(now, token, _to, amount, tokens[token][_to]);\n', '        return true;\n', '      }\n', '      \n', 'function presigntrade(address _from, address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, uint _fee, uint256 orderBookID) public {\n', '    require(!safeGuard,"System Paused by Admin");\n', '    //amount is in amountGet terms\n', '    bytes32 hash = keccak256(abi.encodePacked(address(this), tokenGet, amountGet, tokenGive, amountGive, expires, nonce));\n', '    require(orders[user][hash] || ecrecover(keccak256(abi.encodePacked("\\x19Ethereum Signed Message:\\n32", hash)),v,r,s) == user,"invvalid");\n', '    require(block.number <= expires,"Block Expired");\n', '    require(orderFills[user][hash].add(amount) <= amountGet,"invalid amount");\n', '    splitPresignTrade(_from,tokenGet, amountGet, tokenGive, amountGive, user, amount, _fee, orderBookID);\n', '    orderFills[user][hash] = orderFills[user][hash].add(amount);\n', '    //emit Trade(now, tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, _from);\n', '  }\n', '  \n', '  function splitPresignTrade(address _from, address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount, uint _fee, uint256 orderBookID) internal {\n', '     \n', '      presigntradeBalances(_from,tokenGet, amountGet, tokenGive, amountGive, user, amount, _fee);\n', '      emit Trade(now, tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, _from, orderBookID);\n', '  }\n', '\n', '  function presigntradeBalances(address _from, address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount, uint _fee) internal {\n', '    \n', '    uint tradingFeeXfer = calculatePercentage(amount,tradingFee);\n', '\n', '    tokens[tokenGet][_from] = tokens[tokenGet][_from].sub(amount.add(tradingFeeXfer));\n', '    tokens[tokenGet][user] = tokens[tokenGet][user].add(amount.sub(tradingFeeXfer));\n', '    tokens[address(0)][feeAccount] = tokens[address(0)][feeAccount].add(tradingFeeXfer);\n', '\n', '    tokens[tokenGive][user] = tokens[tokenGive][user].sub(amountGive.mul(amount) / amountGet);\n', '    tokens[tokenGive][_from] = tokens[tokenGive][_from].add(amountGive.mul(amount) / amountGet).sub(_fee);\n', '    tokens[tokenGive][msg.sender] = tokens[tokenGive][msg.sender].add(_fee);\n', '  }\n', '\n', '}']