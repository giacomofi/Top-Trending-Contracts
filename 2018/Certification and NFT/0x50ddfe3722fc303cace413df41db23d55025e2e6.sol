['pragma solidity ^0.4.24;\n', '\n', '// Pikewood Fund: collecting fund for club paving: Morgantown, WV\n', '// Live till June, 30\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    \n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '}\n', '\n', 'contract PikewoodFund is Ownable {\n', '    uint constant minContribution = 500000000000000000; // 0.5 ETH\n', '    address public owner;\n', '    mapping (address => uint) public contributors;\n', '\n', '    modifier onlyContributor() {\n', '        require(contributors[msg.sender] > 0);\n', '        _;\n', '    }\n', '\n', '    function PikewoodFund() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function withdraw_funds() public onlyOwner {\n', '        // only owner can withdraw funds at the end of program\n', '        msg.sender.transfer(this.balance);\n', '    }\n', '\n', '    function () public payable {\n', '        if (msg.value >= minContribution) {\n', '            // contribution must be greater than a minimum allowed\n', '            contributors[msg.sender] += msg.value;\n', '        }\n', '    }\n', '    \n', '    function exit() public onlyContributor(){\n', '        uint amount;\n', '        amount = contributors[msg.sender] / 10; // charging 10% org fee if contributor exits\n', '        if (contributors[msg.sender] >= amount){\n', '            contributors[msg.sender] = 0;\n', '            msg.sender.transfer(amount); // transfer must be last\n', '        }\n', '    }\n', '\n', '    function changeOwner(address newOwner) public onlyContributor() {\n', '        // only owner can transfer ownership\n', '        owner = newOwner;\n', '    }\n', '    \n', '    function getFundsCollected() public view returns (uint){\n', '        return this.balance;\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '// Pikewood Fund: collecting fund for club paving: Morgantown, WV\n', '// Live till June, 30\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    \n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '}\n', '\n', 'contract PikewoodFund is Ownable {\n', '    uint constant minContribution = 500000000000000000; // 0.5 ETH\n', '    address public owner;\n', '    mapping (address => uint) public contributors;\n', '\n', '    modifier onlyContributor() {\n', '        require(contributors[msg.sender] > 0);\n', '        _;\n', '    }\n', '\n', '    function PikewoodFund() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function withdraw_funds() public onlyOwner {\n', '        // only owner can withdraw funds at the end of program\n', '        msg.sender.transfer(this.balance);\n', '    }\n', '\n', '    function () public payable {\n', '        if (msg.value >= minContribution) {\n', '            // contribution must be greater than a minimum allowed\n', '            contributors[msg.sender] += msg.value;\n', '        }\n', '    }\n', '    \n', '    function exit() public onlyContributor(){\n', '        uint amount;\n', '        amount = contributors[msg.sender] / 10; // charging 10% org fee if contributor exits\n', '        if (contributors[msg.sender] >= amount){\n', '            contributors[msg.sender] = 0;\n', '            msg.sender.transfer(amount); // transfer must be last\n', '        }\n', '    }\n', '\n', '    function changeOwner(address newOwner) public onlyContributor() {\n', '        // only owner can transfer ownership\n', '        owner = newOwner;\n', '    }\n', '    \n', '    function getFundsCollected() public view returns (uint){\n', '        return this.balance;\n', '    }\n', '}']
