['pragma solidity ^0.4.13;\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Distribution is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    struct Recipient {\n', '        address addr;\n', '        uint256 share;\n', '        uint256 balance;\n', '        uint256 received;\n', '    }\n', '\n', '    uint256 sharesSum;\n', '    uint8 constant maxRecsAmount = 12;\n', '    mapping(address => Recipient) public recs;\n', '    address[maxRecsAmount] public recsLookUpTable; //to iterate\n', '\n', '    event Payment(address indexed to, uint256 value);\n', '    event AddShare(address to, uint256 value);\n', '    event ChangeShare(address to, uint256 value);\n', '    event DeleteShare(address to);\n', '    event ChangeAddessShare(address newAddress);\n', '    event FoundsReceived(uint256 value);\n', '\n', '    function Distribution() public {\n', '        sharesSum = 0;\n', '    }\n', '\n', '    function receiveFunds() public payable {\n', '        emit FoundsReceived(msg.value);\n', '        for (uint8 i = 0; i < maxRecsAmount; i++) {\n', '            Recipient storage rec = recs[recsLookUpTable[i]];\n', '            uint ethAmount = (rec.share.mul(msg.value)).div(sharesSum);\n', '            rec.balance = rec.balance + ethAmount;\n', '        }\n', '    }\n', '\n', '    modifier onlyMembers(){\n', '        require(recs[msg.sender].addr != address(0));\n', '        _;\n', '    }\n', '\n', '    function doPayments() public {\n', '        Recipient storage rec = recs[msg.sender];\n', '        require(rec.balance >= 1e12);\n', '        rec.addr.transfer(rec.balance);\n', '        emit Payment(rec.addr, rec.balance);\n', '        rec.received = (rec.received).add(rec.balance);\n', '        rec.balance = 0;\n', '    }\n', '\n', '    function addShare(address _rec, uint256 share) public onlyOwner {\n', '        require(_rec != address(0));\n', '        require(share > 0);\n', '        require(recs[_rec].addr == address(0));\n', '        recs[_rec].addr = _rec;\n', '        recs[_rec].share = share;\n', '        recs[_rec].received = 0;\n', '        for(uint8 i = 0; i < maxRecsAmount; i++ ) {\n', '            if (recsLookUpTable[i] == address(0)) {\n', '                recsLookUpTable[i] = _rec;\n', '                break;\n', '            }\n', '        }\n', '        sharesSum = sharesSum.add(share);\n', '        emit AddShare(_rec, share);\n', '    }\n', '\n', '    function changeShare(address _rec, uint share) public onlyOwner {\n', '        require(_rec != address(0));\n', '        require(share > 0);\n', '        require(recs[_rec].addr != address(0));\n', '        Recipient storage rec = recs[_rec];\n', '        sharesSum = sharesSum.sub(rec.share).add(share);\n', '        rec.share = share;\n', '        emit ChangeShare(_rec, share);\n', '    }\n', '\n', '    function deleteShare(address _rec) public onlyOwner {\n', '        require(_rec != address(0));\n', '        require(recs[_rec].addr != address(0));\n', '        sharesSum = sharesSum.sub(recs[_rec].share);\n', '        for(uint8 i = 0; i < maxRecsAmount; i++ ) {\n', '            if (recsLookUpTable[i] == recs[_rec].addr) {\n', '                recsLookUpTable[i] = address(0);\n', '                break;\n', '            }\n', '        }\n', '        delete recs[_rec];\n', '        emit DeleteShare(msg.sender);\n', '    }\n', '\n', '    function changeRecipientAddress(address _newRec) public {\n', '        require(msg.sender != address(0));\n', '        require(_newRec != address(0));\n', '        require(recs[msg.sender].addr != address(0));\n', '        require(recs[_newRec].addr == address(0));\n', '        require(recs[msg.sender].addr != _newRec);\n', '\n', '        Recipient storage rec = recs[msg.sender];\n', '        uint256 prevBalance = rec.balance;\n', '        addShare(_newRec, rec.share);\n', '        emit ChangeAddessShare(_newRec);\n', '        deleteShare(msg.sender);\n', '        recs[_newRec].balance = prevBalance;\n', '        emit DeleteShare(msg.sender);\n', '\n', '    }\n', '\n', '    function getMyBalance() public view returns(uint256) {\n', '        return recs[msg.sender].balance;\n', '    }\n', '}']
['pragma solidity ^0.4.13;\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Distribution is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    struct Recipient {\n', '        address addr;\n', '        uint256 share;\n', '        uint256 balance;\n', '        uint256 received;\n', '    }\n', '\n', '    uint256 sharesSum;\n', '    uint8 constant maxRecsAmount = 12;\n', '    mapping(address => Recipient) public recs;\n', '    address[maxRecsAmount] public recsLookUpTable; //to iterate\n', '\n', '    event Payment(address indexed to, uint256 value);\n', '    event AddShare(address to, uint256 value);\n', '    event ChangeShare(address to, uint256 value);\n', '    event DeleteShare(address to);\n', '    event ChangeAddessShare(address newAddress);\n', '    event FoundsReceived(uint256 value);\n', '\n', '    function Distribution() public {\n', '        sharesSum = 0;\n', '    }\n', '\n', '    function receiveFunds() public payable {\n', '        emit FoundsReceived(msg.value);\n', '        for (uint8 i = 0; i < maxRecsAmount; i++) {\n', '            Recipient storage rec = recs[recsLookUpTable[i]];\n', '            uint ethAmount = (rec.share.mul(msg.value)).div(sharesSum);\n', '            rec.balance = rec.balance + ethAmount;\n', '        }\n', '    }\n', '\n', '    modifier onlyMembers(){\n', '        require(recs[msg.sender].addr != address(0));\n', '        _;\n', '    }\n', '\n', '    function doPayments() public {\n', '        Recipient storage rec = recs[msg.sender];\n', '        require(rec.balance >= 1e12);\n', '        rec.addr.transfer(rec.balance);\n', '        emit Payment(rec.addr, rec.balance);\n', '        rec.received = (rec.received).add(rec.balance);\n', '        rec.balance = 0;\n', '    }\n', '\n', '    function addShare(address _rec, uint256 share) public onlyOwner {\n', '        require(_rec != address(0));\n', '        require(share > 0);\n', '        require(recs[_rec].addr == address(0));\n', '        recs[_rec].addr = _rec;\n', '        recs[_rec].share = share;\n', '        recs[_rec].received = 0;\n', '        for(uint8 i = 0; i < maxRecsAmount; i++ ) {\n', '            if (recsLookUpTable[i] == address(0)) {\n', '                recsLookUpTable[i] = _rec;\n', '                break;\n', '            }\n', '        }\n', '        sharesSum = sharesSum.add(share);\n', '        emit AddShare(_rec, share);\n', '    }\n', '\n', '    function changeShare(address _rec, uint share) public onlyOwner {\n', '        require(_rec != address(0));\n', '        require(share > 0);\n', '        require(recs[_rec].addr != address(0));\n', '        Recipient storage rec = recs[_rec];\n', '        sharesSum = sharesSum.sub(rec.share).add(share);\n', '        rec.share = share;\n', '        emit ChangeShare(_rec, share);\n', '    }\n', '\n', '    function deleteShare(address _rec) public onlyOwner {\n', '        require(_rec != address(0));\n', '        require(recs[_rec].addr != address(0));\n', '        sharesSum = sharesSum.sub(recs[_rec].share);\n', '        for(uint8 i = 0; i < maxRecsAmount; i++ ) {\n', '            if (recsLookUpTable[i] == recs[_rec].addr) {\n', '                recsLookUpTable[i] = address(0);\n', '                break;\n', '            }\n', '        }\n', '        delete recs[_rec];\n', '        emit DeleteShare(msg.sender);\n', '    }\n', '\n', '    function changeRecipientAddress(address _newRec) public {\n', '        require(msg.sender != address(0));\n', '        require(_newRec != address(0));\n', '        require(recs[msg.sender].addr != address(0));\n', '        require(recs[_newRec].addr == address(0));\n', '        require(recs[msg.sender].addr != _newRec);\n', '\n', '        Recipient storage rec = recs[msg.sender];\n', '        uint256 prevBalance = rec.balance;\n', '        addShare(_newRec, rec.share);\n', '        emit ChangeAddessShare(_newRec);\n', '        deleteShare(msg.sender);\n', '        recs[_newRec].balance = prevBalance;\n', '        emit DeleteShare(msg.sender);\n', '\n', '    }\n', '\n', '    function getMyBalance() public view returns(uint256) {\n', '        return recs[msg.sender].balance;\n', '    }\n', '}']