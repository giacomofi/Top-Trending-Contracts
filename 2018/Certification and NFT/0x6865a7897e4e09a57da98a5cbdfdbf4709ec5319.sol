['pragma solidity ^0.4.25;\n', '\n', 'contract Ownerable{\n', '    \n', '    address public owner;\n', '\n', '    address public delegate;\n', '\n', '    constructor() public{\n', '        owner = msg.sender;\n', '        delegate = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner,"Permission denied");\n', '        _;\n', '    }\n', '\n', '    modifier onlyDelegate() {\n', '        require(msg.sender == delegate,"Permission denied");\n', '        _;\n', '    }\n', '    \n', '    modifier onlyOwnerOrDelegate() {\n', '        require(msg.sender == owner||msg.sender == delegate,"Permission denied");\n', '        _;\n', '    }\n', '    \n', '    function changeOwner(address newOwner) public onlyOwner{\n', '        require(newOwner!= 0x0,"address is invalid");\n', '        owner = newOwner;\n', '    }\n', '    \n', '    function changeDelegate(address newDelegate) public onlyOwner{\n', '        require(newDelegate!= 0x0,"address is invalid");\n', '        delegate = newDelegate;\n', '    }\n', '    \n', '}\n', '\n', 'contract Pausable is Ownerable{\n', '  event Paused();\n', '  event Unpaused();\n', '\n', '  bool private _paused = false;\n', '\n', '  /**\n', '   * @return true if the contract is paused, false otherwise.\n', '   */\n', '  function paused() public view returns(bool) {\n', '    return _paused;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!_paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(_paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() public onlyOwner whenNotPaused {\n', '    _paused = true;\n', '    emit Paused();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() public onlyOwner whenPaused {\n', '    _paused = false;\n', '    emit Unpaused();\n', '  }\n', '}\n', '\n', 'contract EthTransfer is Pausable{\n', '    \n', '    using SafeMath for uint256;\n', '    \n', '    uint256 constant ADMIN_DEPOIST_TIME_INTERVAL = 24 hours;\n', '    uint256 constant ADMIN_DEPOIST_MAX_AMOUNT = 50 ether;\n', '    uint256 last_time_admin_depoist = 0;\n', '    \n', '    uint constant HOUSE_EDGE_PERCENT = 15; //1.5%\n', '    uint constant HOUSE_EDGE_MINIMUM_AMOUNT = 0.00045 ether;\n', '    \n', '    uint256 public _total_house_edge = 0;\n', '    \n', '    uint256 public _ID = 1; //AUTO INCREMENT\n', '    uint256 public _newChannelID = 10000;\n', '        \n', '    event addChannelSucc    (uint256 indexed id,uint256 channelID,string name);\n', '    event rechargeSucc      (uint256 indexed id,uint256 channelID,address user,uint256 amount,string ext);\n', '    event depositSucc       (uint256 indexed id,uint256 channelID,address beneficiary,uint256 amount,uint256 houseEdge,string ext);\n', '    event withdrawSucc      (uint256 indexed id,uint256 amount);\n', '    event depositBySuperAdminSucc           (uint256 indexed id,uint256 amount,address beneficiary);\n', '    event changeChannelDelegateSucc         (uint256 indexed id,address newDelegate);\n', '    \n', '    mapping(uint256 => Channel) public _channelMap; // channelID => channel info\n', '    \n', '    mapping(address => uint256) public _idMap; // delegate => channelID\n', '    \n', '    function addNewChannel(string name_,address channelDelegate_,uint256 partnershipCooperationBounsRate_) public onlyDelegate{\n', '        require(_idMap[channelDelegate_] == 0,"An address can only manage one channel.");\n', '        \n', '        _channelMap[_newChannelID] = Channel(name_,_newChannelID,channelDelegate_,0,partnershipCooperationBounsRate_);\n', '        _idMap[channelDelegate_] = _newChannelID;\n', '        \n', '        emit addChannelSucc(_ID,_newChannelID,name_);\n', '        _newChannelID++;\n', '        _ID++;\n', '    }\n', '    \n', '    function() public payable{\n', '        revert();\n', '    }\n', '    \n', '    function recharge(uint256 channelID_,string ext_) public payable whenNotPaused{\n', '        Channel storage targetChannel = _channelMap[channelID_];\n', '        require(targetChannel.channelID!=0,"target Channel is no exist");\n', '        uint256 inEth = msg.value;\n', '\n', '        uint256 partnershipCooperationBouns = inEth * targetChannel.partnershipCooperationBounsRate / 100 ;\n', '        _total_house_edge = _total_house_edge.add(partnershipCooperationBouns);\n', '\n', '        uint256 targetEth = inEth.sub(partnershipCooperationBouns);\n', '        targetChannel.totalEth = targetChannel.totalEth.add(targetEth);\n', '        \n', '        emit rechargeSucc(_ID, channelID_, msg.sender, inEth, ext_);\n', '        _ID++;\n', '    }\n', '\n', '    function changeChannelDelegate(address newDelegate_) public whenNotPaused{\n', '        require(_idMap[msg.sender] != 0,"this address isn\'t a manager");\n', '        Channel storage channelInfo = _channelMap[_idMap[msg.sender]];\n', '        require(channelInfo.channelDelegate == msg.sender,"You are not the administrator of this channel.");\n', '        require(_idMap[newDelegate_] == 0,"An address can only manage one channel.");\n', '        \n', '        channelInfo.channelDelegate = newDelegate_;\n', '        _idMap[msg.sender] = 0;\n', '        _idMap[newDelegate_] = channelInfo.channelID;\n', '        \n', '        emit changeChannelDelegateSucc(_ID, newDelegate_);\n', '        _ID++;\n', '    }    \n', '    \n', '    function deposit(address beneficiary_,uint256 amount_,string ext_) public whenNotPaused{\n', '        //Verify user identity\n', '        require(_idMap[msg.sender] != 0,"this address isn\'t a manager");\n', '        \n', '        Channel storage channelInfo = _channelMap[_idMap[msg.sender]];\n', '        //Query administrator privileges\n', '        require(channelInfo.channelDelegate == msg.sender,"You are not the administrator of this channel.");\n', '        //Is order completed?\n', '        bytes32 orderId = keccak256(abi.encodePacked(ext_));\n', '        require(!channelInfo.channelOrderHistory[orderId],"this order is deposit already");\n', '        channelInfo.channelOrderHistory[orderId] = true;\n', '        \n', '        uint256 totalLeftEth = channelInfo.totalEth.sub(amount_);\n', '        \n', '        uint houseEdge = amount_ * HOUSE_EDGE_PERCENT / 1000;\n', '        if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {\n', '            houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;\n', '        }\n', '        \n', '        channelInfo.totalEth = totalLeftEth.sub(houseEdge);\n', '        _total_house_edge = _total_house_edge.add(houseEdge);\n', '        \n', '        beneficiary_.transfer(amount_);\n', '        \n', '        emit depositSucc(_ID, channelInfo.channelID, beneficiary_, amount_, houseEdge, ext_);\n', '        _ID++;\n', '    }\n', '    \n', '    function depositByDelegate(address beneficiary_,uint256 amount_,string ext_, bytes32 r, bytes32 s, uint8 v) public onlyDelegate whenNotPaused{\n', '        //Verify user identity \n', '        bytes32 signatureHash = keccak256(abi.encodePacked(beneficiary_, amount_,ext_));\n', '        address secretSigner = ecrecover(signatureHash, v, r, s);\n', '        require(_idMap[secretSigner] != 0,"this address isn\'t a manager");\n', '        \n', '        Channel storage channelInfo = _channelMap[_idMap[secretSigner]];\n', '        //Query administrator privileges\n', '        require(channelInfo.channelDelegate == secretSigner,"You are not the administrator of this channel.");\n', '        //Is order completed?\n', '        bytes32 orderId = keccak256(abi.encodePacked(ext_));\n', '        require(!channelInfo.channelOrderHistory[orderId],"this order is deposit already");\n', '        channelInfo.channelOrderHistory[orderId] = true;\n', '        \n', '        uint256 totalLeftEth = channelInfo.totalEth.sub(amount_);\n', '        \n', '        uint houseEdge = amount_ * HOUSE_EDGE_PERCENT / 1000;\n', '        if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {\n', '            houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;\n', '        }\n', '        \n', '        channelInfo.totalEth = totalLeftEth.sub(houseEdge);\n', '        _total_house_edge = _total_house_edge.add(houseEdge);\n', '        \n', '        beneficiary_.transfer(amount_);\n', '        \n', '        emit depositSucc(_ID, channelInfo.channelID, beneficiary_, amount_, houseEdge, ext_);\n', '        _ID++;\n', '    }\n', '    \n', '    function withdraw() public onlyOwnerOrDelegate {\n', '        require(_total_house_edge > 0,"no edge to withdraw");\n', '        owner.transfer(_total_house_edge);\n', '        \n', '        emit withdrawSucc(_ID,_total_house_edge);\n', '        _total_house_edge = 0;\n', '        _ID++;\n', '    }\n', '    \n', '    function depositBySuperAdmin(uint256 channelID_, uint256 amount_, address beneficiary_) public onlyOwner{\n', '        require(now - last_time_admin_depoist >= ADMIN_DEPOIST_TIME_INTERVAL," super admin time limit");\n', '        require(amount_ <= ADMIN_DEPOIST_MAX_AMOUNT," over super admin deposit amount limit");\n', '        last_time_admin_depoist = now;\n', '        Channel storage channelInfo = _channelMap[channelID_];\n', '        uint256 totalLeftEth = channelInfo.totalEth.sub(amount_);\n', '        channelInfo.totalEth = totalLeftEth;\n', '        beneficiary_.transfer(amount_);\n', '        \n', '        emit depositBySuperAdminSucc(_ID, amount_, beneficiary_);\n', '        _ID++;\n', '    }\n', '    \n', '    struct Channel{\n', '        string name;\n', '        uint256 channelID;\n', '        address channelDelegate;\n', '        uint256 totalEth;\n', '        uint256 partnershipCooperationBounsRate;\n', '        mapping(bytes32 => bool) channelOrderHistory;\n', '    }\n', '    \n', '    function destory() public onlyOwner whenPaused{\n', '        selfdestruct(owner);    \n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath v0.1.9\n', ' * @dev Math operations with safety checks that throw on error\n', ' * change notes:  original SafeMath library from OpenZeppelin modified by Inventor\n', ' * - added sqrt\n', ' * - added sq\n', ' * - added pwr\n', ' * - changed asserts to requires with error log outputs\n', ' * - removed div, its useless\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b)\n', '        internal\n', '        pure\n', '        returns (uint256 c)\n', '    {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        require(c / a == b, "SafeMath mul failed");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b)\n', '        internal\n', '        pure\n', '        returns (uint256)\n', '    {\n', '        require(b <= a, "SafeMath sub failed");\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b)\n', '        internal\n', '        pure\n', '        returns (uint256 c)\n', '    {\n', '        c = a + b;\n', '        require(c >= a, "SafeMath add failed");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev gives square root of given x.\n', '     */\n', '    function sqrt(uint256 x)\n', '        internal\n', '        pure\n', '        returns (uint256 y)\n', '    {\n', '        uint256 z = ((add(x,1)) / 2);\n', '        y = x;\n', '        while (z < y)\n', '        {\n', '            y = z;\n', '            z = ((add((x / z),z)) / 2);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev gives square. multiplies x by x\n', '     */\n', '    function sq(uint256 x)\n', '        internal\n', '        pure\n', '        returns (uint256)\n', '    {\n', '        return (mul(x,x));\n', '    }\n', '\n', '    /**\n', '     * @dev x to the power of y\n', '     */\n', '    function pwr(uint256 x, uint256 y)\n', '        internal\n', '        pure\n', '        returns (uint256)\n', '    {\n', '        if (x==0)\n', '            return (0);\n', '        else if (y==0)\n', '            return (1);\n', '        else\n', '        {\n', '            uint256 z = x;\n', '            for (uint256 i=1; i < y; i++)\n', '                z = mul(z,x);\n', '            return (z);\n', '        }\n', '    }\n', '}']