['pragma solidity ^0.4.19;\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title SafeMath32\n', ' * @dev SafeMath library implemented for uint32\n', ' */\n', 'library SafeMath32 {\n', '\n', '  function mul(uint32 a, uint32 b) internal pure returns (uint32) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint32 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint32 a, uint32 b) internal pure returns (uint32) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint32 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint32 a, uint32 b) internal pure returns (uint32) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint32 a, uint32 b) internal pure returns (uint32) {\n', '    uint32 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title SafeMath16\n', ' * @dev SafeMath library implemented for uint16\n', ' */\n', 'library SafeMath16 {\n', '\n', '  function mul(uint16 a, uint16 b) internal pure returns (uint16) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint16 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint16 a, uint16 b) internal pure returns (uint16) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint16 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint16 a, uint16 b) internal pure returns (uint16) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint16 a, uint16 b) internal pure returns (uint16) {\n', '    uint16 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC721 {\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);\n', '  event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 _balance);\n', '  function ownerOf(uint256 _tokenId) public view returns (address _owner);\n', '  function transfer(address _to, uint256 _tokenId) public;\n', '  function approve(address _to, uint256 _tokenId) public;\n', '  function takeOwnership(uint256 _tokenId) public;\n', '}\n', 'contract PreSell is Ownable,ERC721{\n', '    using SafeMath for uint256;\n', '    struct Coach{\n', '        uint256 drawPrice;\n', '        uint256 emoteRate;\n', '        uint256 sellPrice;\n', '        uint8   isSell;\n', '        uint8   category;\n', '    }\n', '    event initialcoach(uint _id);\n', '    event drawcoach(uint _id,address _owner);\n', '    event purChase(uint _id, address _newowner, address _oldowner);\n', '    event inviteCoachBack(address _from,address _to, uint _fee);\n', '    Coach[] public originCoach;\n', '    Coach[] public coaches; \n', '    mapping(uint=>address) coachToOwner;\n', '    mapping(uint=>uint) public coachAllnums;\n', '    mapping(address=>uint) ownerCoachCount;\n', '    mapping (uint => address) coachApprovals;\n', '    //modifier\n', '    modifier onlyOwnerOf(uint _id) {\n', '        require(msg.sender == coachToOwner[_id]);\n', '        _;\n', '    }\n', '    //owner draw _money\n', '    function withdraw() external onlyOwner {\n', '        owner.transfer(address(this).balance);\n', '    }\n', '    //initial coach and coach nums;\n', '    function initialCoach(uint _price,uint _emoterate,uint8 _category,uint _num) public onlyOwner{ \n', '      uint id = originCoach.push(Coach(_price,_emoterate,0,0,_category)) - 1;\n', '      coachAllnums[id] = _num;\n', '      emit initialcoach(id);\n', '    }\n', '    function drawCoach(uint _id,address _address) public payable{ \n', '        require(msg.value == originCoach[_id].drawPrice && coachAllnums[_id] > 0 );\n', '        uint id = coaches.push(originCoach[_id]) -1;\n', '        coachToOwner[id] = msg.sender;\n', '        ownerCoachCount[msg.sender] = ownerCoachCount[msg.sender].add(1);\n', '        coachAllnums[_id]  = coachAllnums[_id].sub(1);\n', '        if(_address != 0){ \n', '                 uint inviteFee = msg.value * 5 / 100;\n', '                 _address.transfer(inviteFee);\n', '                 emit inviteCoachBack(msg.sender,_address,inviteFee);\n', '        }\n', '        emit drawcoach(_id,msg.sender);\n', '    }\n', '     //ERC721 functions;\n', '    function balanceOf(address _owner) public view returns (uint256 _balance) {\n', '        return ownerCoachCount[_owner];\n', '    }\n', '\n', '    function ownerOf(uint256 _tokenId) public view returns (address _owner) {\n', '        return coachToOwner[_tokenId];\n', '    }\n', '    function _transfer(address _from, address _to, uint256 _tokenId) private {\n', '        require(_to != _from);\n', '        ownerCoachCount[_to] = ownerCoachCount[_to].add(1) ;\n', '        ownerCoachCount[_from] = ownerCoachCount[_from].sub(1);\n', '        coachToOwner[_tokenId] = _to;\n', '        emit Transfer(_from, _to, _tokenId);\n', '    }\n', '    function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {\n', '        _transfer(msg.sender, _to, _tokenId);\n', '    }\n', '\n', '    function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {\n', '        coachApprovals[_tokenId] = _to;\n', '        emit Approval(msg.sender, _to, _tokenId);\n', '    }\n', '    function takeOwnership(uint256 _tokenId) public {\n', '        require(coachApprovals[_tokenId] == msg.sender && coachToOwner[_tokenId] != msg.sender);\n', '        address owner = ownerOf(_tokenId);\n', '        _transfer(owner, msg.sender, _tokenId);\n', '    }\n', '    //market functions\n', '        //market functions\n', '    function setCoachPrice(uint _id,uint _price) public onlyOwnerOf(_id){ \n', '        coaches[_id].isSell = 1;\n', '        coaches[_id].sellPrice = _price;\n', '    }\n', '    function coachTakeOff(uint _id) public onlyOwnerOf(_id){\n', '        coaches[_id].isSell = 0;\n', '    }\n', '    function purchase(uint _id) public payable{\n', '        require(coaches[_id].isSell == 1 && msg.value == coaches[_id].sellPrice && msg.sender != coachToOwner[_id]);\n', '        address owner = coachToOwner[_id];\n', '        ownerCoachCount[owner] = ownerCoachCount[owner].sub(1) ;\n', '        ownerCoachCount[msg.sender] = ownerCoachCount[msg.sender].add(1);\n', '        coachToOwner[_id] = msg.sender;\n', '        owner.transfer(msg.value);\n', '        emit purChase(_id,msg.sender,owner);\n', '    }\n', '    \n', '}']
['pragma solidity ^0.4.19;\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title SafeMath32\n', ' * @dev SafeMath library implemented for uint32\n', ' */\n', 'library SafeMath32 {\n', '\n', '  function mul(uint32 a, uint32 b) internal pure returns (uint32) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint32 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint32 a, uint32 b) internal pure returns (uint32) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint32 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint32 a, uint32 b) internal pure returns (uint32) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint32 a, uint32 b) internal pure returns (uint32) {\n', '    uint32 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title SafeMath16\n', ' * @dev SafeMath library implemented for uint16\n', ' */\n', 'library SafeMath16 {\n', '\n', '  function mul(uint16 a, uint16 b) internal pure returns (uint16) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint16 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint16 a, uint16 b) internal pure returns (uint16) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint16 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint16 a, uint16 b) internal pure returns (uint16) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint16 a, uint16 b) internal pure returns (uint16) {\n', '    uint16 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC721 {\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);\n', '  event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 _balance);\n', '  function ownerOf(uint256 _tokenId) public view returns (address _owner);\n', '  function transfer(address _to, uint256 _tokenId) public;\n', '  function approve(address _to, uint256 _tokenId) public;\n', '  function takeOwnership(uint256 _tokenId) public;\n', '}\n', 'contract PreSell is Ownable,ERC721{\n', '    using SafeMath for uint256;\n', '    struct Coach{\n', '        uint256 drawPrice;\n', '        uint256 emoteRate;\n', '        uint256 sellPrice;\n', '        uint8   isSell;\n', '        uint8   category;\n', '    }\n', '    event initialcoach(uint _id);\n', '    event drawcoach(uint _id,address _owner);\n', '    event purChase(uint _id, address _newowner, address _oldowner);\n', '    event inviteCoachBack(address _from,address _to, uint _fee);\n', '    Coach[] public originCoach;\n', '    Coach[] public coaches; \n', '    mapping(uint=>address) coachToOwner;\n', '    mapping(uint=>uint) public coachAllnums;\n', '    mapping(address=>uint) ownerCoachCount;\n', '    mapping (uint => address) coachApprovals;\n', '    //modifier\n', '    modifier onlyOwnerOf(uint _id) {\n', '        require(msg.sender == coachToOwner[_id]);\n', '        _;\n', '    }\n', '    //owner draw _money\n', '    function withdraw() external onlyOwner {\n', '        owner.transfer(address(this).balance);\n', '    }\n', '    //initial coach and coach nums;\n', '    function initialCoach(uint _price,uint _emoterate,uint8 _category,uint _num) public onlyOwner{ \n', '      uint id = originCoach.push(Coach(_price,_emoterate,0,0,_category)) - 1;\n', '      coachAllnums[id] = _num;\n', '      emit initialcoach(id);\n', '    }\n', '    function drawCoach(uint _id,address _address) public payable{ \n', '        require(msg.value == originCoach[_id].drawPrice && coachAllnums[_id] > 0 );\n', '        uint id = coaches.push(originCoach[_id]) -1;\n', '        coachToOwner[id] = msg.sender;\n', '        ownerCoachCount[msg.sender] = ownerCoachCount[msg.sender].add(1);\n', '        coachAllnums[_id]  = coachAllnums[_id].sub(1);\n', '        if(_address != 0){ \n', '                 uint inviteFee = msg.value * 5 / 100;\n', '                 _address.transfer(inviteFee);\n', '                 emit inviteCoachBack(msg.sender,_address,inviteFee);\n', '        }\n', '        emit drawcoach(_id,msg.sender);\n', '    }\n', '     //ERC721 functions;\n', '    function balanceOf(address _owner) public view returns (uint256 _balance) {\n', '        return ownerCoachCount[_owner];\n', '    }\n', '\n', '    function ownerOf(uint256 _tokenId) public view returns (address _owner) {\n', '        return coachToOwner[_tokenId];\n', '    }\n', '    function _transfer(address _from, address _to, uint256 _tokenId) private {\n', '        require(_to != _from);\n', '        ownerCoachCount[_to] = ownerCoachCount[_to].add(1) ;\n', '        ownerCoachCount[_from] = ownerCoachCount[_from].sub(1);\n', '        coachToOwner[_tokenId] = _to;\n', '        emit Transfer(_from, _to, _tokenId);\n', '    }\n', '    function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {\n', '        _transfer(msg.sender, _to, _tokenId);\n', '    }\n', '\n', '    function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {\n', '        coachApprovals[_tokenId] = _to;\n', '        emit Approval(msg.sender, _to, _tokenId);\n', '    }\n', '    function takeOwnership(uint256 _tokenId) public {\n', '        require(coachApprovals[_tokenId] == msg.sender && coachToOwner[_tokenId] != msg.sender);\n', '        address owner = ownerOf(_tokenId);\n', '        _transfer(owner, msg.sender, _tokenId);\n', '    }\n', '    //market functions\n', '        //market functions\n', '    function setCoachPrice(uint _id,uint _price) public onlyOwnerOf(_id){ \n', '        coaches[_id].isSell = 1;\n', '        coaches[_id].sellPrice = _price;\n', '    }\n', '    function coachTakeOff(uint _id) public onlyOwnerOf(_id){\n', '        coaches[_id].isSell = 0;\n', '    }\n', '    function purchase(uint _id) public payable{\n', '        require(coaches[_id].isSell == 1 && msg.value == coaches[_id].sellPrice && msg.sender != coachToOwner[_id]);\n', '        address owner = coachToOwner[_id];\n', '        ownerCoachCount[owner] = ownerCoachCount[owner].sub(1) ;\n', '        ownerCoachCount[msg.sender] = ownerCoachCount[msg.sender].add(1);\n', '        coachToOwner[_id] = msg.sender;\n', '        owner.transfer(msg.value);\n', '        emit purChase(_id,msg.sender,owner);\n', '    }\n', '    \n', '}']