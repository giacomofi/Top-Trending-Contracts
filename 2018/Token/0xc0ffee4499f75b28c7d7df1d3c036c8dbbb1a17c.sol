['/**\n', ' *  Coffee\n', ' *\n', ' *  Just a very simple example of deploying a contract at a vanity address\n', ' *  across several chains.\n', ' *\n', ' *  See: https://blog.ricmoo.com/contract-addresses-549074919ec8\n', ' *\n', ' */\n', '\n', 'pragma solidity ^0.4.20;\n', '\n', 'contract Coffee {\n', '\n', '    address _owner;\n', '\n', '    uint48 _mgCaffeine;\n', '    uint48 _count;\n', '\n', '    function Coffee() {\n', '        _owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     *   Allow the owner to change the account that controls this contract.\n', '     *\n', '     *   We may wish to use powerful computers that may be public or\n', '     *   semi-public to compute the private key we use to deploy the contract,\n', '     *   to a vanity adddress. So once deployed, we want to move it to a\n', '     *   cold-storage key.\n', '     */\n', '    function setOwner(address owner) {\n', '        require(msg.sender == _owner);\n', '        _owner = owner;\n', '    }\n', '\n', '    /**\n', '     *   status()\n', '     *\n', '     *   Returns the number of drinks and amount of caffeine this contract\n', '     *   has been responsible for installing into the developer.\n', '     */\n', '    function status() public constant returns (uint48 count, uint48 mgCaffeine) {\n', '        count = _count;\n', '        mgCaffeine = _mgCaffeine;\n', '    }\n', '\n', '    /**\n', '     *  withdraw(amount, count, mgCaffeine)\n', '     *\n', '     *  Withdraws funds from this contract to the owner, indicating how many drinks\n', '     *  and how much caffeine these funds will be used to install into the develoepr.\n', '     */\n', '    function withdraw(uint256 amount, uint8 count, uint16 mgCaffeine) public {\n', '        require(msg.sender == _owner);\n', '        _owner.transfer(amount);\n', '        _count += count;\n', '        _mgCaffeine += mgCaffeine;\n', '    }\n', '\n', '    // Let this contract accept payments\n', '    function () public payable { }\n', '}']
['/**\n', ' *  Coffee\n', ' *\n', ' *  Just a very simple example of deploying a contract at a vanity address\n', ' *  across several chains.\n', ' *\n', ' *  See: https://blog.ricmoo.com/contract-addresses-549074919ec8\n', ' *\n', ' */\n', '\n', 'pragma solidity ^0.4.20;\n', '\n', 'contract Coffee {\n', '\n', '    address _owner;\n', '\n', '    uint48 _mgCaffeine;\n', '    uint48 _count;\n', '\n', '    function Coffee() {\n', '        _owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     *   Allow the owner to change the account that controls this contract.\n', '     *\n', '     *   We may wish to use powerful computers that may be public or\n', '     *   semi-public to compute the private key we use to deploy the contract,\n', '     *   to a vanity adddress. So once deployed, we want to move it to a\n', '     *   cold-storage key.\n', '     */\n', '    function setOwner(address owner) {\n', '        require(msg.sender == _owner);\n', '        _owner = owner;\n', '    }\n', '\n', '    /**\n', '     *   status()\n', '     *\n', '     *   Returns the number of drinks and amount of caffeine this contract\n', '     *   has been responsible for installing into the developer.\n', '     */\n', '    function status() public constant returns (uint48 count, uint48 mgCaffeine) {\n', '        count = _count;\n', '        mgCaffeine = _mgCaffeine;\n', '    }\n', '\n', '    /**\n', '     *  withdraw(amount, count, mgCaffeine)\n', '     *\n', '     *  Withdraws funds from this contract to the owner, indicating how many drinks\n', '     *  and how much caffeine these funds will be used to install into the develoepr.\n', '     */\n', '    function withdraw(uint256 amount, uint8 count, uint16 mgCaffeine) public {\n', '        require(msg.sender == _owner);\n', '        _owner.transfer(amount);\n', '        _count += count;\n', '        _mgCaffeine += mgCaffeine;\n', '    }\n', '\n', '    // Let this contract accept payments\n', '    function () public payable { }\n', '}']