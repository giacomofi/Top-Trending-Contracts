['pragma solidity ^0.4.24;\n', '\n', '//Slightly modified SafeMath library - includes a min function\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function min(uint a, uint b) internal pure returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', '*This contract allows users to sign up for the DDA Cooperative Membership.\n', '*To complete membership DDA will provide instructions to complete KYC/AML verification\n', '*through a system external to this contract.\n', '*/\n', 'contract Membership {\n', '    using SafeMath for uint256;\n', '    \n', '    /*Variables*/\n', '    address public owner;\n', '    //Memebership fees\n', '    uint public memberFee;\n', '\n', '    /*Structs*/\n', '    /**\n', '    *@dev Keeps member information \n', '    */\n', '    struct Member {\n', '        uint memberId;\n', '        uint membershipType;\n', '    }\n', '    \n', '    /*Mappings*/\n', '    //Members information\n', '    mapping(address => Member) public members;\n', '    address[] public membersAccts;\n', '    mapping (address => uint) public membersAcctsIndex;\n', '\n', '    /*Events*/\n', '    event UpdateMemberAddress(address _from, address _to);\n', '    event NewMember(address _address, uint _memberId, uint _membershipType);\n', '    event Refund(address _address, uint _amount);\n', '\n', '    /*Modifiers*/\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    /*Functions*/\n', '    /**\n', '    *@dev Constructor - Sets owner\n', '    */\n', '     constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /*\n', '    *@dev Updates the fee amount\n', '    *@param _memberFee fee amount for member\n', '    */\n', '    function setFee(uint _memberFee) public onlyOwner() {\n', '        //define fee structure for the three membership types\n', '        memberFee = _memberFee;\n', '    }\n', '    \n', '    /**\n', '    *@notice Allows a user to become DDA members if they pay the fee. However, they still have to complete\n', '    *complete KYC/AML verification off line\n', '    *@dev This creates and transfers the token to the msg.sender\n', '    */\n', '    function requestMembership() public payable {\n', '        Member storage sender = members[msg.sender];\n', '        require(msg.value >= memberFee && sender.membershipType == 0 );\n', '        membersAccts.push(msg.sender);\n', '        sender.memberId = membersAccts.length;\n', '        sender.membershipType = 1;\n', '        emit NewMember(msg.sender, sender.memberId, sender.membershipType);\n', '    }\n', '    \n', '    /**\n', '    *@dev This updates/transfers the member address \n', '    *@param _from is the current member address\n', '    *@param _to is the address the member would like to update their current address with\n', '    */\n', '    function updateMemberAddress(address _from, address _to) public onlyOwner {\n', '        require(_to != address(0));\n', '        Member storage currentAddress = members[_from];\n', '        Member storage newAddress = members[_to];\n', '        require(newAddress.memberId == 0);\n', '        newAddress.memberId = currentAddress.memberId;\n', '        newAddress.membershipType = currentAddress.membershipType;\n', '        membersAccts[currentAddress.memberId - 1] = _to;\n', '        currentAddress.memberId = 0;\n', '        currentAddress.membershipType = 0;\n', '        emit UpdateMemberAddress(_from, _to);\n', '    }\n', '\n', '    /**\n', '    *@dev Use this function to set membershipType for the member\n', '    *@param _memberAddress address of member that we need to update membershipType\n', '    *@param _membershipType type of membership to assign to member\n', '    */\n', '    function setMembershipType(address _memberAddress,  uint _membershipType) public onlyOwner{\n', '        Member storage memberAddress = members[_memberAddress];\n', '        memberAddress.membershipType = _membershipType;\n', '    }\n', '\n', '    /**\n', '    *@dev Use this function to set memberId for the member\n', '    *@param _memberAddress address of member that we need to update membershipType\n', '    *@param _memberId is the manually assigned memberId\n', '    */\n', '    function setMemberId(address _memberAddress,  uint _memberId) public onlyOwner{\n', '        Member storage memberAddress = members[_memberAddress];\n', '        memberAddress.memberId = _memberId;\n', '    }\n', '\n', '    /**\n', '    *@dev Use this function to remove member acct from array memberAcct\n', '    *@param _memberAddress address of member to remove\n', '    */\n', '    function removeMemberAcct(address _memberAddress) public onlyOwner{\n', '        require(_memberAddress != address(0));\n', '        uint256 indexToDelete;\n', '        uint256 lastAcctIndex;\n', '        address lastAdd;\n', '        Member storage memberAddress = members[_memberAddress];\n', '        memberAddress.memberId = 0;\n', '        memberAddress.membershipType = 0;\n', '        indexToDelete = membersAcctsIndex[_memberAddress];\n', '        lastAcctIndex = membersAccts.length.sub(1);\n', '        lastAdd = membersAccts[lastAcctIndex];\n', '        membersAccts[indexToDelete]=lastAdd;\n', '        membersAcctsIndex[lastAdd] = indexToDelete;   \n', '        membersAccts.length--;\n', '        membersAcctsIndex[_memberAddress]=0; \n', '    }\n', '\n', '\n', '    /**\n', '    *@dev Use this function to member acct from array memberAcct\n', '    *@param _memberAddress address of member to add\n', '    */\n', '    function addMemberAcct(address _memberAddress) public onlyOwner{\n', '        require(_memberAddress != address(0));\n', '        Member storage memberAddress = members[_memberAddress];\n', '        membersAcctsIndex[_memberAddress] = membersAccts.length; \n', '        membersAccts.push(_memberAddress);\n', '        memberAddress.memberId = membersAccts.length;\n', '        memberAddress.membershipType = 1;\n', '        emit NewMember(_memberAddress, memberAddress.memberId, memberAddress.membershipType);\n', '    }\n', '\n', '    /**\n', '    *@dev getter function to get all membersAccts\n', '    */\n', '    function getMembers() view public returns (address[]){\n', '        return membersAccts;\n', '    }\n', '    \n', '    /**\n', '    *@dev Get member information\n', '    *@param _memberAddress address to pull the memberId, membershipType and membership\n', '    */\n', '    function getMember(address _memberAddress) view public returns(uint, uint) {\n', '        return(members[_memberAddress].memberId, members[_memberAddress].membershipType);\n', '    }\n', '\n', '    /**\n', '    *@dev Gets length of array containing all member accounts or total supply\n', '    */\n', '    function countMembers() view public returns(uint) {\n', '        return membersAccts.length;\n', '    }\n', '\n', '    /**\n', '    *@dev Gets membership type\n', '    *@param _memberAddress address to view the membershipType\n', '    */\n', '    function getMembershipType(address _memberAddress) public constant returns(uint){\n', '        return members[_memberAddress].membershipType;\n', '    }\n', '    \n', '    /**\n', '    *@dev Allows the owner to set a new owner address\n', '    *@param _new_owner the new owner address\n', '    */\n', '    function setOwner(address _new_owner) public onlyOwner() { \n', '        owner = _new_owner; \n', '    }\n', '\n', '    /**\n', '    *@dev Refund money if KYC/AML fails\n', '    *@param _to address to send refund\n', '    *@param _amount to refund. If no amount  is specified the current memberFee is refunded\n', '    */\n', '    function refund(address _to, uint _amount) public onlyOwner {\n', '        require (_to != address(0));\n', '        if (_amount == 0) {_amount = memberFee;}\n', '        removeMemberAcct(_to);\n', '        _to.transfer(_amount);\n', '        emit Refund(_to, _amount);\n', '    }\n', '\n', '    /**\n', '    *@dev Allow owner to withdraw funds\n', '    *@param _to address to send funds\n', '    *@param _amount to send\n', '    */\n', '    function withdraw(address _to, uint _amount) public onlyOwner {\n', '        _to.transfer(_amount);\n', '    }    \n', '}']
['pragma solidity ^0.4.24;\n', '\n', '//Slightly modified SafeMath library - includes a min function\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function min(uint a, uint b) internal pure returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', '*This contract allows users to sign up for the DDA Cooperative Membership.\n', '*To complete membership DDA will provide instructions to complete KYC/AML verification\n', '*through a system external to this contract.\n', '*/\n', 'contract Membership {\n', '    using SafeMath for uint256;\n', '    \n', '    /*Variables*/\n', '    address public owner;\n', '    //Memebership fees\n', '    uint public memberFee;\n', '\n', '    /*Structs*/\n', '    /**\n', '    *@dev Keeps member information \n', '    */\n', '    struct Member {\n', '        uint memberId;\n', '        uint membershipType;\n', '    }\n', '    \n', '    /*Mappings*/\n', '    //Members information\n', '    mapping(address => Member) public members;\n', '    address[] public membersAccts;\n', '    mapping (address => uint) public membersAcctsIndex;\n', '\n', '    /*Events*/\n', '    event UpdateMemberAddress(address _from, address _to);\n', '    event NewMember(address _address, uint _memberId, uint _membershipType);\n', '    event Refund(address _address, uint _amount);\n', '\n', '    /*Modifiers*/\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    /*Functions*/\n', '    /**\n', '    *@dev Constructor - Sets owner\n', '    */\n', '     constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /*\n', '    *@dev Updates the fee amount\n', '    *@param _memberFee fee amount for member\n', '    */\n', '    function setFee(uint _memberFee) public onlyOwner() {\n', '        //define fee structure for the three membership types\n', '        memberFee = _memberFee;\n', '    }\n', '    \n', '    /**\n', '    *@notice Allows a user to become DDA members if they pay the fee. However, they still have to complete\n', '    *complete KYC/AML verification off line\n', '    *@dev This creates and transfers the token to the msg.sender\n', '    */\n', '    function requestMembership() public payable {\n', '        Member storage sender = members[msg.sender];\n', '        require(msg.value >= memberFee && sender.membershipType == 0 );\n', '        membersAccts.push(msg.sender);\n', '        sender.memberId = membersAccts.length;\n', '        sender.membershipType = 1;\n', '        emit NewMember(msg.sender, sender.memberId, sender.membershipType);\n', '    }\n', '    \n', '    /**\n', '    *@dev This updates/transfers the member address \n', '    *@param _from is the current member address\n', '    *@param _to is the address the member would like to update their current address with\n', '    */\n', '    function updateMemberAddress(address _from, address _to) public onlyOwner {\n', '        require(_to != address(0));\n', '        Member storage currentAddress = members[_from];\n', '        Member storage newAddress = members[_to];\n', '        require(newAddress.memberId == 0);\n', '        newAddress.memberId = currentAddress.memberId;\n', '        newAddress.membershipType = currentAddress.membershipType;\n', '        membersAccts[currentAddress.memberId - 1] = _to;\n', '        currentAddress.memberId = 0;\n', '        currentAddress.membershipType = 0;\n', '        emit UpdateMemberAddress(_from, _to);\n', '    }\n', '\n', '    /**\n', '    *@dev Use this function to set membershipType for the member\n', '    *@param _memberAddress address of member that we need to update membershipType\n', '    *@param _membershipType type of membership to assign to member\n', '    */\n', '    function setMembershipType(address _memberAddress,  uint _membershipType) public onlyOwner{\n', '        Member storage memberAddress = members[_memberAddress];\n', '        memberAddress.membershipType = _membershipType;\n', '    }\n', '\n', '    /**\n', '    *@dev Use this function to set memberId for the member\n', '    *@param _memberAddress address of member that we need to update membershipType\n', '    *@param _memberId is the manually assigned memberId\n', '    */\n', '    function setMemberId(address _memberAddress,  uint _memberId) public onlyOwner{\n', '        Member storage memberAddress = members[_memberAddress];\n', '        memberAddress.memberId = _memberId;\n', '    }\n', '\n', '    /**\n', '    *@dev Use this function to remove member acct from array memberAcct\n', '    *@param _memberAddress address of member to remove\n', '    */\n', '    function removeMemberAcct(address _memberAddress) public onlyOwner{\n', '        require(_memberAddress != address(0));\n', '        uint256 indexToDelete;\n', '        uint256 lastAcctIndex;\n', '        address lastAdd;\n', '        Member storage memberAddress = members[_memberAddress];\n', '        memberAddress.memberId = 0;\n', '        memberAddress.membershipType = 0;\n', '        indexToDelete = membersAcctsIndex[_memberAddress];\n', '        lastAcctIndex = membersAccts.length.sub(1);\n', '        lastAdd = membersAccts[lastAcctIndex];\n', '        membersAccts[indexToDelete]=lastAdd;\n', '        membersAcctsIndex[lastAdd] = indexToDelete;   \n', '        membersAccts.length--;\n', '        membersAcctsIndex[_memberAddress]=0; \n', '    }\n', '\n', '\n', '    /**\n', '    *@dev Use this function to member acct from array memberAcct\n', '    *@param _memberAddress address of member to add\n', '    */\n', '    function addMemberAcct(address _memberAddress) public onlyOwner{\n', '        require(_memberAddress != address(0));\n', '        Member storage memberAddress = members[_memberAddress];\n', '        membersAcctsIndex[_memberAddress] = membersAccts.length; \n', '        membersAccts.push(_memberAddress);\n', '        memberAddress.memberId = membersAccts.length;\n', '        memberAddress.membershipType = 1;\n', '        emit NewMember(_memberAddress, memberAddress.memberId, memberAddress.membershipType);\n', '    }\n', '\n', '    /**\n', '    *@dev getter function to get all membersAccts\n', '    */\n', '    function getMembers() view public returns (address[]){\n', '        return membersAccts;\n', '    }\n', '    \n', '    /**\n', '    *@dev Get member information\n', '    *@param _memberAddress address to pull the memberId, membershipType and membership\n', '    */\n', '    function getMember(address _memberAddress) view public returns(uint, uint) {\n', '        return(members[_memberAddress].memberId, members[_memberAddress].membershipType);\n', '    }\n', '\n', '    /**\n', '    *@dev Gets length of array containing all member accounts or total supply\n', '    */\n', '    function countMembers() view public returns(uint) {\n', '        return membersAccts.length;\n', '    }\n', '\n', '    /**\n', '    *@dev Gets membership type\n', '    *@param _memberAddress address to view the membershipType\n', '    */\n', '    function getMembershipType(address _memberAddress) public constant returns(uint){\n', '        return members[_memberAddress].membershipType;\n', '    }\n', '    \n', '    /**\n', '    *@dev Allows the owner to set a new owner address\n', '    *@param _new_owner the new owner address\n', '    */\n', '    function setOwner(address _new_owner) public onlyOwner() { \n', '        owner = _new_owner; \n', '    }\n', '\n', '    /**\n', '    *@dev Refund money if KYC/AML fails\n', '    *@param _to address to send refund\n', '    *@param _amount to refund. If no amount  is specified the current memberFee is refunded\n', '    */\n', '    function refund(address _to, uint _amount) public onlyOwner {\n', '        require (_to != address(0));\n', '        if (_amount == 0) {_amount = memberFee;}\n', '        removeMemberAcct(_to);\n', '        _to.transfer(_amount);\n', '        emit Refund(_to, _amount);\n', '    }\n', '\n', '    /**\n', '    *@dev Allow owner to withdraw funds\n', '    *@param _to address to send funds\n', '    *@param _amount to send\n', '    */\n', '    function withdraw(address _to, uint _amount) public onlyOwner {\n', '        _to.transfer(_amount);\n', '    }    \n', '}']
