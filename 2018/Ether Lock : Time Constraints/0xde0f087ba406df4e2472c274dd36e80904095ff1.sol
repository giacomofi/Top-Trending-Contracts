['pragma solidity ^0.4.24;\n', '\n', 'contract ZTHInterface {\n', '    function buyAndSetDivPercentage(address _referredBy, uint8 _divChoice, string providedUnhashedPass) public payable returns (uint);\n', '    function balanceOf(address who) public view returns (uint);\n', '    function transfer(address _to, uint _value)     public returns (bool);\n', '    function transferFrom(address _from, address _toAddress, uint _amountOfTokens) public returns (bool);\n', '    function exit() public;\n', '    function sell(uint amountOfTokens) public;\n', '    function withdraw(address _recipient) public;\n', '}\n', '\n', '// The Zethr Token Bankrolls aren&#39;t quite done being tested yet,\n', '// so here is a bankroll shell that we are using in the meantime.\n', '\n', '// Will store tokens & divs @ the set div% until the token bankrolls are fully tested & battle ready\n', 'contract ZethrTokenBankrollShell {\n', '    // Setup Zethr\n', '    address ZethrAddress = address(0xD48B633045af65fF636F3c6edd744748351E020D);\n', '    ZTHInterface ZethrContract = ZTHInterface(ZethrAddress);\n', '    \n', '    address private owner;\n', '    \n', '    // Read-only after constructor\n', '    uint8 public divRate;\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    constructor (uint8 thisDivRate) public {\n', '        owner = msg.sender;\n', '        divRate = thisDivRate;\n', '    }\n', '    \n', '    // Accept ETH\n', '    function () public payable {}\n', '    \n', '    // Buy tokens at this contract&#39;s divRate\n', '    function buyTokens() public payable onlyOwner {\n', '        ZethrContract.buyAndSetDivPercentage.value(address(this).balance)(address(0x0), divRate, "0x0");\n', '    }\n', '    \n', '    // Transfer tokens to newTokenBankroll\n', '    // Transfer dividends to master bankroll\n', '    function transferTokensAndDividends(address newTokenBankroll, address masterBankroll) public onlyOwner {\n', '        // Withdraw divs to new masterBankroll\n', '        ZethrContract.withdraw(masterBankroll);\n', '        \n', '        // Transfer tokens to newTokenBankroll\n', '        ZethrContract.transfer(newTokenBankroll, ZethrContract.balanceOf(address(this)));\n', '    }\n', '}']