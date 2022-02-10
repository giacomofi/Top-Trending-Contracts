['pragma solidity ^0.7.0;\n', '\n', '// SPDX-License-Identifier: MIT\n', 'interface ERC20Interface {\n', '    function totalSupply() \n', '\t\texternal \n', '\t\tview \n', '\t\treturns (uint);\n', '\n', '    function balanceOf(address tokenOwner) \n', '\t\texternal \n', '\t\tview \n', '\t\treturns (uint balance);\n', '    \n', '\tfunction allowance\n', '\t\t(address tokenOwner, address spender) \n', '\t\texternal \n', '\t\tview \n', '\t\treturns (uint remaining);\n', '\n', '    function transfer(address to, uint tokens) \t\t\t\texternal \n', '\t\treturns (bool success);\n', '    \n', '\tfunction approve(address spender, uint tokens) \t\texternal \n', '\t\treturns (bool success);\n', '\n', '    function transferFrom \n', '\t\t(address from, address to, uint tokens) \t\t\t\texternal \n', '\t\treturns (bool success);\n', '\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '    \n', '    \n', '}\n', '\n', '///Contract that vests 200K GRO then payout after every month for the next 24 months. \n', 'contract GrowthLockContract {\n', '    \n', '    address private owner; \n', '    address private safe;\n', '    address private mike;\n', '    address private ghost;\n', '    address private dev; \n', '    uint256 public time; \n', '    uint private constant devAmount = 4166.66 * 1 ether;\n', '    uint private constant managementAmount = 1388.88 * 1 ether;\n', '    \n', '    //2629743 = 30 days. \n', '    uint public constant locktime = 2629743; \n', '    \n', '    //0x09e64c2B61a5f1690Ee6fbeD9baf5D6990F8dFd0 is Growth Token address\n', '    ERC20Interface private constant token = ERC20Interface(0x09e64c2B61a5f1690Ee6fbeD9baf5D6990F8dFd0);\n', '    \n', '    \n', '    constructor () {\n', '        owner = msg.sender;\n', '        \n', '        time = block.timestamp; \n', '        \n', '        \n', '        mike = 0x70F5FB6BE943162545a496eD120495B05dC5ce07;\n', '        ghost = 0x6811101D884557Eba52DF3Ea0417A3036D5b9FCd;\n', '        safe = 0xC4faC8CA576B9c8B971fA36916aEE062d84b4901;\n', '        dev = 0xB0632a01ee778E09625BcE2a257e221b49E79696;\n', '        \n', '\n', '  \n', '    }\n', '    \n', '    //Modifier to prevent everyone except owner from using contract.  \n', '    modifier onlyOwner(){\n', '        require(msg.sender == owner, "Unauthorized to call. ");\n', '        _;\n', '    }\n', '    \n', '    //Admin can deposit the initial vested amount.  You can only use this function once.  \n', '    function depositToken(uint amount) public onlyOwner {\n', '        require(amount > 0, "Amount must be greater than zero");\n', '        \n', '        require(token.transferFrom(msg.sender, address(this), amount) == true, "Inefficient balance or Unauthorized to pay. ");\n', '\n', '    }\n', '    \n', '    \n', '    //Admin pays dev and management team.\n', '    function payToken() public onlyOwner {\n', "        //check if it's past the next payperiod.  \n", '        require(block.timestamp >= (time + locktime), "Period not reached yet. ");\n', '\n', '        \n', '        //Sends dev payment. \n', '        require(token.transfer(dev, devAmount) == true, "You don\'t have enough in balance. ");\n', '        \n', '        //sends management payments.\n', '        require(token.transfer(safe, managementAmount) == true, "You don\'t have enough in balance. ");\n', '        require(token.transfer(mike, managementAmount) == true, "You don\'t have enough in balance. ");\n', '        require(token.transfer(ghost, managementAmount) == true, "You don\'t have enough in balance. ");\n', '        \n', '        time += locktime; \n', '        \n', '    }\n', '    \n', '    \n', '    //Used to check contract balance. \n', '    function getBalance() view public returns (uint) {\n', '        return token.balanceOf(address(this));\n', '    }\n', '    \n', '    ///Updates the owner of the contract\n', '    function updateOwner(address newOwner) public onlyOwner {\n', '\n', '        owner = newOwner; \n', '    }\n', '    \n', '    //Used incase management teams lost their wallet and needs to updated.  \n', '    function updateManagement(address _mike, address _ghost, address _safe, address _dev) public onlyOwner {\n', '\n', '        mike = _mike;\n', '        ghost = _ghost;\n', '        safe = _safe;\n', '        dev = _dev;\n', '    }\n', '    \n', '    //Check who owner is. \n', '    function getOwner() view public returns (address) {\n', '        return owner; \n', '    }\n', '    \n', '    \n', '}']