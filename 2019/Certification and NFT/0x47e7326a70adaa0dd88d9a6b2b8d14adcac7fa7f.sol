['pragma solidity ^0.5.0;\n', '\n', '\n', 'contract IOwnable {\n', '\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnerChanged(address _oldOwner, address _newOwner);\n', '\n', '    function changeOwner(address _newOwner) public;\n', '    function acceptOwnership() public;\n', '}\n', '\n', 'contract IVoting is IOwnable {\n', '\n', '    uint public startDate;\n', '    uint public endDate;\n', '    uint public votesYes;\n', '    uint public votesNo;\n', '    uint8 public subject;\n', '    uint public nextVotingDate;\n', '\n', '\n', '    event InitVoting(uint startDate, uint endDate, uint8 subject);\n', '    event Vote(address _address, int _vote);\n', '\n', '    function initProlongationVoting() public;\n', '    function initTapChangeVoting(uint8 newPercent) public;\n', '    function inProgress() public view returns (bool);\n', '    function yes(address _address, uint _votes) public;\n', '    function no(address _address, uint _votes) public;\n', '    function vote(address _address) public view returns (int);\n', '    function votesTotal() public view returns (uint);\n', '    function isSubjectApproved() public view returns (bool);\n', '}\n', '\n', 'contract Ownable is IOwnable {\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '        emit OwnerChanged(address(0), owner);\n', '    }\n', '\n', '    function changeOwner(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnerChanged(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', 'contract SafeMath {\n', '\n', '    function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b > 0);\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(a >= b);\n', '        return a - b;\n', '    }\n', '\n', '    function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Voting is IVoting, SafeMath, Ownable {\n', '\n', '    uint16 private currentVoting;\n', '    mapping (address => int) private votes;\n', '    mapping (address => uint16) private lastVoting;\n', '    bool private prolongationVoted;\n', '\n', '    function inProgress() public view returns (bool) {\n', '        return now >= startDate && now <= endDate;\n', '    }\n', '\n', '    function init(uint _startDate, uint _duration, uint8 _subject) private {\n', '        require(!inProgress());\n', '        require(_startDate >= now);\n', '        require(_subject > 0 && _subject <= 100);\n', '        currentVoting += 1;\n', '        startDate = _startDate;\n', '        endDate = _startDate + _duration;\n', '        votesYes = 0;\n', '        votesNo = 0;\n', '        subject = _subject;\n', '        emit InitVoting(_startDate, endDate, subject);\n', '    }\n', '\n', '    function yes(address _address, uint _votes) public onlyOwner {\n', '        require(inProgress());\n', '        require(lastVoting[_address] < currentVoting);\n', '        require(_votes > 0);\n', '        lastVoting[_address] = currentVoting;\n', '        votes[_address] = int(_votes);\n', '        votesYes = safeAdd(votesYes, _votes);\n', '        emit Vote(_address, int(_votes));\n', '    }\n', '\n', '    function no(address _address, uint _votes) public onlyOwner {\n', '        require(inProgress());\n', '        require(lastVoting[_address] < currentVoting);\n', '        require(_votes > 0);\n', '        lastVoting[_address] = currentVoting;\n', '        votes[_address] = 0 - int(_votes);\n', '        votesNo = safeAdd(votesNo, _votes);\n', '        emit Vote(_address, 0 - int(_votes));\n', '    }\n', '\n', '    function vote(address _address) public view returns (int) {\n', '        if (lastVoting[_address] == currentVoting) {\n', '            return votes[_address];\n', '        } else {\n', '            return 0;\n', '        }\n', '    }\n', '\n', '    function votesTotal() public view returns (uint) {\n', '        return safeAdd(votesYes, votesNo);\n', '    }\n', '\n', '    function isSubjectApproved() public view returns (bool) {\n', '        return votesYes > votesNo;\n', '    }\n', '\n', '    function initProlongationVoting() public onlyOwner {\n', '        require(!prolongationVoted);\n', '        init(now, 24 hours, 30);\n', '        prolongationVoted = true;\n', '    }\n', '\n', '    function initTapChangeVoting(uint8 newPercent) public onlyOwner {\n', '        require(now > nextVotingDate);\n', '        init(now, 14 days, newPercent);\n', '        nextVotingDate = now + 30 days;\n', '    }\n', '}']