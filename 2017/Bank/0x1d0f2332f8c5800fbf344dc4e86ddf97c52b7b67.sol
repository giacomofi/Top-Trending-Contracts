['pragma solidity ^0.4.18;\n', '\n', '// Each deployed Splitter contract has a constant array of recipients.\n', '// When the Splitter receives Ether, it will immediately divide this Ether up\n', '// and send it to the recipients.\n', 'contract Splitter\n', '{\n', '\taddress[] public recipients;\n', '\t\n', '\tfunction Splitter(address[] _recipients) public\n', '\t{\n', '\t    require(_recipients.length >= 1);\n', '\t\trecipients = _recipients;\n', '\t}\n', '\t\n', '\tfunction() payable public\n', '\t{\n', '\t\tuint256 amountOfRecipients = recipients.length;\n', '\t\tuint256 etherPerRecipient = msg.value / amountOfRecipients;\n', '\t\t\n', '\t\tif (etherPerRecipient == 0) return;\n', '\t\t\n', '\t\tfor (uint256 i=0; i<amountOfRecipients; i++)\n', '\t\t{\n', '\t\t\trecipients[i].transfer(etherPerRecipient);\n', '\t\t}\n', '\t}\n', '}\n', '\n', 'contract SplitterService\n', '{\n', '    address private owner;\n', '    uint256 public feeForSplitterCreation;\n', '    \n', '    mapping(address => address[]) public addressToSplittersCreated;\n', '    mapping(address => bool) public addressIsSplitter;\n', '    mapping(address => string) public splitterNames;\n', '    \n', '    function SplitterService() public\n', '    {\n', '        owner = msg.sender;\n', '        feeForSplitterCreation = 0.001 ether;\n', '    }\n', '    \n', '    function createSplitter(address[] recipients, string name) external payable\n', '    {\n', '        require(msg.value >= feeForSplitterCreation);\n', '        address newSplitterAddress = new Splitter(recipients);\n', '        addressToSplittersCreated[msg.sender].push(newSplitterAddress);\n', '        addressIsSplitter[newSplitterAddress] = true;\n', '        splitterNames[newSplitterAddress] = name;\n', '    }\n', '    \n', '    ////////////////////////////////////////\n', '    // Owner functions\n', '    \n', '    function setFee(uint256 newFee) external\n', '    {\n', '        require(msg.sender == owner);\n', '        require(newFee <= 0.01 ether);\n', '        feeForSplitterCreation = newFee;\n', '    }\n', '    \n', '    function ownerWithdrawFees() external\n', '    {\n', '        owner.transfer(this.balance);\n', '    }\n', '    \n', '    function transferOwnership(address newOwner) external\n', '    {\n', '        require(msg.sender == owner);\n', '        owner = newOwner;\n', '    }\n', '}']