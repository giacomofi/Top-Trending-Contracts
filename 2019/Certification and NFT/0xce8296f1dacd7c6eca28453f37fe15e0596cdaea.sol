['// File: contracts/Set.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'library Set {\n', '    // We define a new struct datatype that will be used to\n', '    // hold its data in the calling contract.\n', '    struct Data { \n', '        mapping(address => bool) flags;\n', '    }\n', '\n', '    // Note that the first parameter is of type "storage\n', '    // reference" and thus only its storage address and not\n', '    // its contents is passed as part of the call.  This is a\n', '    // special feature of library functions.  It is idiomatic\n', '    // to call the first parameter `self`, if the function can\n', '    // be seen as a method of that object.\n', '    function insert(Data storage self, address value)\n', '        public\n', '        returns (bool)\n', '    {\n', '        if (self.flags[value])\n', '            return false; // already there\n', '        self.flags[value] = true;\n', '        return true;\n', '    }\n', '\n', '    function remove(Data storage self, address value)\n', '        public\n', '        returns (bool)\n', '    {\n', '        if (!self.flags[value])\n', '            return false; // not there\n', '        self.flags[value] = false;\n', '        return true;\n', '    }\n', '\n', '    function contains(Data storage self, address value)\n', '        public\n', '        view\n', '        returns (bool)\n', '    {\n', '        return self.flags[value];\n', '    }\n', '}\n', '\n', '// File: contracts/Crowdsourcing.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', 'contract Crowdsourcing {\n', '    address public _owner;\n', '    string task;\n', '    uint private _total;\n', '    uint private _amount;\n', '    string private _content;\n', '    uint private _current  = 0;\n', '    address[] private workersArr;\n', '    uint private workerCount;\n', '    mapping(address => bool) public paid;\n', '    mapping(address => string) private answers;\n', '    Set.Data workers;\n', '    \n', '    event toVerification (\n', '        address indexed id\n', '    );\n', '    \n', '    event rejection (\n', '        address indexed rejected\n', '    );\n', '    \n', '    constructor(address owner, uint total, string memory content, uint money) public payable{\n', '        require(money % total == 0);\n', '        _owner = owner;\n', '        _total = total;\n', '        _amount = money;\n', '        _content = content;\n', '\n', '    }\n', '    \n', '    function getTotal() public view returns (uint) {\n', '        return _total;\n', '    }\n', '    \n', '    function getAmount() public view returns (uint) {\n', '        return _amount;\n', '    }\n', '    \n', '    function getContent() public view returns (string memory) {\n', '        return _content;\n', '    }\n', '\n', '    function isPaying() public view returns (bool) {\n', '        return _current  < _total;\n', '    }\n', '    \n', '    function getAnswers(address f) public view returns (string memory) {\n', '        require (msg.sender == _owner);\n', '        return answers[f];\n', '    }\n', '    \n', '    function addMoney() public payable {\n', '        require((msg.value + _amount) % _total == 0);\n', '        _amount += msg.value;\n', '    }\n', '    \n', '    // fallback function\n', '    function() external payable { }\n', '    \n', '    function stop() public {\n', '        require (msg.sender == _owner);\n', '        selfdestruct(msg.sender);\n', '    }\n', '    \n', '    function accept(address payable target) public payable {\n', '        require(msg.sender == _owner);\n', '        require(!paid[target]);\n', '        require(Set.contains(workers, target));\n', '        require(_current  < _total);\n', '        paid[target] = true;\n', '        _current ++;\n', '        target.transfer(_amount / _total);\n', '    }\n', '    \n', '    function reject(address payable target) public payable {\n', '        require(msg.sender == _owner);\n', '        require(!paid[target]);\n', '        require(Set.contains(workers, target));\n', '        require(_current  < _total);\n', '        emit rejection(target);\n', "        answers[target] = '';\n", '    }\n', '    \n', '    function answer(string calldata ans) external {\n', '        answers[msg.sender] = ans;\n', '        workersArr.push(msg.sender);\n', '        if (Set.insert(workers, msg.sender))\n', '        {\n', '            workerCount++;\n', '        }\n', '        emit toVerification(msg.sender);\n', '    }\n', '\n', '    function getWorkers(uint number) public view returns (address) {\n', '        require(msg.sender == _owner);\n', '        require(number < workerCount);\n', '        return workersArr[number];\n', '    }\n', '\n', '    function getNumberOfWorkers() public view returns (uint) {\n', '        require(msg.sender == _owner);\n', '        return workerCount;\n', '    }\n', '\n', '    function isPaid(address a) public view returns (bool) {\n', '        return paid[a];\n', '    }\n', '    \n', '    function myPay() public view returns (bool) {\n', '        return paid[msg.sender];\n', '    }\n', '    \n', '    function myAnswer() public view returns (string memory) {\n', '        if (bytes(answers[msg.sender]).length == 0) return "";\n', '        return answers[msg.sender];\n', '    }\n', '}\n', '\n', '// File: contracts/CrdSet-dev.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', 'contract CrdSet {\n', '    Crowdsourcing[] public list;\n', '    event newContract(Crowdsourcing indexed c);\n', '\n', '    function createCC(uint total, string memory content) public payable returns (Crowdsourcing){\n', '        require(msg.value % total == 0, "Amount of money need to be dividable by the total number of answers");\n', '        Crowdsourcing a = new Crowdsourcing(msg.sender, total, content, msg.value);\n', '        list.push(a);\n', '        address(a).transfer(msg.value);\n', '        emit newContract(a);\n', '        return a;\n', '    }\n', '    \n', '    function getContracCount() public view returns (uint) {\n', '        return list.length;\n', '    }\n', '    \n', '}']