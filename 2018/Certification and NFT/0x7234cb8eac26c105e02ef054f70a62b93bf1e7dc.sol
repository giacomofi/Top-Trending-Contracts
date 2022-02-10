['pragma solidity ^0.4.18;\n', '\n', 'contract DPOS {\n', '    uint256 public limit;\n', '    address public owner;\n', '    struct VoteItem {\n', '        string content;\n', '        uint agreeNum;\n', '        uint disagreeNum;\n', '    }\n', '    struct VoteRecord {\n', '        address voter;\n', '        bool choice;\n', '    }\n', '\n', '    mapping (uint => VoteItem) public voteItems;\n', '    mapping (uint => VoteRecord[]) public voteRecords;\n', '\n', '    event Create(uint indexed _id, string indexed _content);\n', '    event Vote(uint indexed _id, address indexed _voter, bool indexed _choice);\n', '\n', '    function DPOS() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    function setLimit(uint256 _limit) public onlyOwner returns (bool) {\n', '        limit = _limit;\n', '        return true;\n', '    }\n', '    \n', '    function lengthOfRecord(uint256 _id) public view returns (uint length) {\n', '        return voteRecords[_id].length;\n', '    }\n', '\n', '    function create(uint _id, string _content) public onlyOwner returns (bool) {\n', '        VoteItem memory item = VoteItem({content: _content, agreeNum: 0, disagreeNum: 0});\n', '        voteItems[_id] = item;\n', '        Create(_id, _content);\n', '        return true;\n', '    }\n', '\n', '    function vote(uint _id, address _voter, bool _choice) public onlyOwner returns (bool) {\n', '        if (_choice) {\n', '            voteItems[_id].agreeNum += 1;\n', '        } else {\n', '            voteItems[_id].disagreeNum += 1;\n', '        }\n', '        VoteRecord memory record = VoteRecord({voter: _voter, choice: _choice});\n', '        voteRecords[_id].push(record);\n', '        Vote(_id, _voter, _choice);\n', '        return true;\n', '    }\n', '}']