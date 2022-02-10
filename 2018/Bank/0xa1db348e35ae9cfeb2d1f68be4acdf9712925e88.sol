['pragma solidity ^0.4.21;\n', '\n', 'contract holder {\n', '    function onIncome() public payable; \n', '}\n', '\n', 'contract BatchControl {\n', '\n', '    mapping (address => uint256) public allowed;\n', '    address public owner;\n', '    uint256 public price;\n', '    holder public holderContract;\n', '\n', '    event BUY(address buyer, uint256 amount, uint256 total);\n', '    event HOLDER(address holder);\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    constructor(uint256 _price) public {\n', '        owner = msg.sender;\n', '        allowed[owner] = 1000000;\n', '        price = _price;\n', '    }\n', '    \n', '    function withdrawal() public {\n', '        owner.transfer(address(this).balance);\n', '    }\n', '    \n', '    function buy(uint256 amount) payable public {\n', '        uint256 total = price * amount;\n', '        assert(total >= price);\n', '        require(msg.value >= total);\n', '        \n', '        allowed[msg.sender] += amount;\n', '        \n', '        if (holderContract != address(0)) {\n', '            holderContract.onIncome.value(msg.value)();\n', '        }\n', '        emit BUY(msg.sender, amount, allowed[msg.sender]);\n', '    }\n', '    \n', '    function setPrice(uint256 _p) onlyOwner public {\n', '        price = _p;\n', '    }\n', '    \n', '    function setHolder(address _holder) onlyOwner public {\n', '        holderContract = holder(_holder);\n', '        \n', '        emit HOLDER(_holder);\n', '    }\n', '}']
['pragma solidity ^0.4.21;\n', '\n', 'contract holder {\n', '    function onIncome() public payable; \n', '}\n', '\n', 'contract BatchControl {\n', '\n', '    mapping (address => uint256) public allowed;\n', '    address public owner;\n', '    uint256 public price;\n', '    holder public holderContract;\n', '\n', '    event BUY(address buyer, uint256 amount, uint256 total);\n', '    event HOLDER(address holder);\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    constructor(uint256 _price) public {\n', '        owner = msg.sender;\n', '        allowed[owner] = 1000000;\n', '        price = _price;\n', '    }\n', '    \n', '    function withdrawal() public {\n', '        owner.transfer(address(this).balance);\n', '    }\n', '    \n', '    function buy(uint256 amount) payable public {\n', '        uint256 total = price * amount;\n', '        assert(total >= price);\n', '        require(msg.value >= total);\n', '        \n', '        allowed[msg.sender] += amount;\n', '        \n', '        if (holderContract != address(0)) {\n', '            holderContract.onIncome.value(msg.value)();\n', '        }\n', '        emit BUY(msg.sender, amount, allowed[msg.sender]);\n', '    }\n', '    \n', '    function setPrice(uint256 _p) onlyOwner public {\n', '        price = _p;\n', '    }\n', '    \n', '    function setHolder(address _holder) onlyOwner public {\n', '        holderContract = holder(_holder);\n', '        \n', '        emit HOLDER(_holder);\n', '    }\n', '}']
