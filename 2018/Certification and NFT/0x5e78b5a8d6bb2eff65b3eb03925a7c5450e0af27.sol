['pragma solidity ^0.4.16;\n', '\n', '\n', '/**\n', ' \n', ' \n', '   ______   ______   __ __ __   ___   ___       __   __      ______      \n', '  /_____/\\ /_____/\\ /_//_//_/\\ /__/\\ /__/\\     /__/\\/__/\\   /_____/\\     \n', '  \\:::_ \\ \\\\:::_ \\ \\\\:\\\\:\\\\:\\ \\\\::\\ \\\\  \\ \\    \\  \\ \\: \\ \\__\\:::_ \\ \\    \n', '   \\:(_) \\ \\\\:\\ \\ \\ \\\\:\\\\:\\\\:\\ \\\\::\\/_\\ .\\ \\    \\::\\_\\::\\/_/\\\\:\\ \\ \\ \\   \n', '    \\: ___\\/ \\:\\ \\ \\ \\\\:\\\\:\\\\:\\ \\\\:: ___::\\ \\    \\_:::   __\\/ \\:\\ \\ \\ \\  \n', '     \\ \\ \\    \\:\\_\\ \\ \\\\:\\\\:\\\\:\\ \\\\: \\ \\\\::\\ \\        \\::\\ \\   \\:\\/.:| | \n', '      \\_\\/     \\_____\\/ \\_______\\/ \\__\\/ \\::\\/         \\__\\/    \\____/_/ \n', '\n', '\n', '\n', '                        ▌ ▐&#183;▪  .▄▄ &#183; ▪  ▄▄▄▄▄\n', '                       ▪█&#183;█▌██ ▐█ ▀. ██ •██  \n', '                       ▐█▐█•▐█&#183;▄▀▀▀█▄▐█&#183; ▐█.▪\n', '                        ███ ▐█▌▐█▄▪▐█▐█▌ ▐█▌&#183;\n', '                       . ▀  ▀▀▀ ▀▀▀▀ ▀▀▀ ▀▀▀ \n', ' \n', '  ██████╗  ██████╗ ██╗    ██╗██╗  ██╗██╗  ██╗██████╗    ██╗ ██████╗ \n', '  ██╔══██╗██╔═══██╗██║    ██║██║  ██║██║  ██║██╔══██╗   ██║██╔═══██╗\n', '  ██████╔╝██║   ██║██║ █╗ ██║███████║███████║██║  ██║   ██║██║   ██║\n', '  ██╔═══╝ ██║   ██║██║███╗██║██╔══██║╚════██║██║  ██║   ██║██║   ██║\n', '  ██║     ╚██████╔╝╚███╔███╔╝██║  ██║     ██║██████╔╝██╗██║╚██████╔╝\n', '  ╚═╝      ╚═════╝  ╚══╝╚══╝ ╚═╝  ╚═╝     ╚═╝╚═════╝ ╚═╝╚═╝ ╚═════╝ \n', '  \n', ' \n', '* HOW DOES THAT WORK?\n', '\n', '* Every trade, buy or sell, has a 15% flat transaction fee applied. Instead of this going to the exchange,\n', '* the fee is split between all currently held tokens! \n', '* 15% of all volume this cryptocurrency ever experiences, is set aside for you the token holders, as ethereum rewards that you can instantly withdraw whenever you&#39;d like.\n', '\n', 'COMPLETELY DECENTRALIZED, HUMANS CAN&#39;T SHUT IT DOWN.\n', '\n', 'We updated PoWH 4D graphics. \n', 'We are grateful to weirdsgn.com and icondesignlab.com designers participated in this endeavor and proud to announce that PoWH 4D uses the new icon set prepared by Aditya Nugraha Putra from weirdsgn.com. \n', 'Previous PoWH 4D icons are available as interface theme here: https://rarlab.com/themes/PoWH 4D_Classic_48x36.theme.rar \n', '"Repair" command efficiency is improved for recovery record protected RAR5 archives. Now it can detect deletions and insertions of unlimited size also as shuffled data including data taken from several recovery record protected archives and merged into a single file in arbitrary order. \n', '"Turn PC off when done" archiving option is changed to "When done" drop down list, so you can turn off, hibernate or sleep your PC after completing archiving. \n', 'Use -ioff or -ioff1 command line switch to turn PC off, -ioff2 to hibernate and -ioff3 to sleep your PC after completing an operation. \n', 'If encoding of comment file specified in -z<file> switch is not defined with -sc switch, RAR attempts to detect UTF-8, UTF-16LE and UTF-16BE encodings based on the byte order mask and data validity tests. \n', 'PoWH 4D attempts to detect ANSI, OEM and UTF-8 encodings of ZIP archive comments automatically. \n', '"Internal viewer/Use DOS encoding" option in "Settings/Viewer" is replaced with "Internal viewer/Autodetect encoding". If "Autodetect encoding" is enabled, the internal viewer attempts to detect ANSI (Windows), OEM (DOS), UTF-8 and UTF-16 encodings. \n', 'Normally Windows Explorer context menu contains only extraction commands if single archive has been right clicked. You can override this by specifying one or more space separated masks in "Always display archiving items for" option in Settings/Integration/Context menu items", so archiving commands are always displayed for these file types even if file was recognized as archive. If you wish both archiving and extraction commands present for all archives, place "*" here. \n', 'SFX module "SetupCode" command accepts an optional integer parameter allowing to control mapping of setup program and SFX own error codes. It is also accessible as "Exit code adjustment" option in "Advanced SFX options/Setup" dialog. \n', 'New "Show more information" PoWH 4D command line -im switch. It can be used with "t" command to issue a message also in case of successful archive test result. Without this switch "t" command completes silently if no errors are found. \n', 'Every ethereum transaction is handled by a piece of unchangable blockchain programming known as a smart-contract.\n', 'No need to fear, you&#39;re only entrusting your hard-earned ETH to an algorithmic robot accountant running on a decentralized blockchain network created by a russian madman worth billions, enforced by subsidized Chinese GPU farms that are consuming an amount of electricity larger than most third-world countries, sustaining an exchange that runs without any human involvement for as long as the ethereum network exists\n', 'Welcome to cryptocurrency.\n', 'Your tokens are safe, or somebody would be yelling at us by now.\n', '\n', '*/\n', '\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', 'contract PoWH4D { \n', '    // Public variables of the token\n', '    string public name = "PoWH4D"; string public symbol = "P4D"; uint8 public decimals = 18; uint256 public totalSupply; uint256 public PoWH4DSupply = 800000; uint256 public buyPrice = 2000;\n', '    address public creator;\n', '    // This creates an array with all balances\n', '    mapping \n', '        (address => uint256)    \n', '            public balanceOf;\n', '    mapping     \n', '        (address => mapping \n', '            (address => uint256\n', '            )\n', '        ) public allowance;\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer\n', '            (address indexed from, \n', '            address indexed to, \n', '            uint256 value\n', '            );\n', '    event FundTransfer\n', '            (address backer, \n', '            uint amount, \n', '            bool isContribution);\n', '    \n', '    \n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    function PoWH4D() public {\n', '        totalSupply = PoWH4DSupply * 10 ** uint256(decimals);  \n', '        balanceOf[msg.sender] = totalSupply;   \n', '        creator = msg.sender;\n', '    }\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '      \n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    function () payable internal {\n', '\t\n', '\t    uint amount;\n', '        amount = msg.value * buyPrice;\n', '        uint amountRaised;                                     \n', '        amountRaised += msg.value;                            \n', '        require(balanceOf[creator] >= amount);               \n', '        balanceOf[msg.sender] += amount;                 \n', '        balanceOf[creator] -= amount;                        \n', '        Transfer(creator, msg.sender, amount);               \n', '        creator.transfer(amountRaised);\n', '    }\n', '\n', ' }\n', ' \n', ' /*YOU SHOULD READ THE CONTRACT BEFORE*/']
['pragma solidity ^0.4.16;\n', '\n', '\n', '/**\n', ' \n', ' \n', '   ______   ______   __ __ __   ___   ___       __   __      ______      \n', '  /_____/\\ /_____/\\ /_//_//_/\\ /__/\\ /__/\\     /__/\\/__/\\   /_____/\\     \n', '  \\:::_ \\ \\\\:::_ \\ \\\\:\\\\:\\\\:\\ \\\\::\\ \\\\  \\ \\    \\  \\ \\: \\ \\__\\:::_ \\ \\    \n', '   \\:(_) \\ \\\\:\\ \\ \\ \\\\:\\\\:\\\\:\\ \\\\::\\/_\\ .\\ \\    \\::\\_\\::\\/_/\\\\:\\ \\ \\ \\   \n', '    \\: ___\\/ \\:\\ \\ \\ \\\\:\\\\:\\\\:\\ \\\\:: ___::\\ \\    \\_:::   __\\/ \\:\\ \\ \\ \\  \n', '     \\ \\ \\    \\:\\_\\ \\ \\\\:\\\\:\\\\:\\ \\\\: \\ \\\\::\\ \\        \\::\\ \\   \\:\\/.:| | \n', '      \\_\\/     \\_____\\/ \\_______\\/ \\__\\/ \\::\\/         \\__\\/    \\____/_/ \n', '\n', '\n', '\n', '                        ▌ ▐·▪  .▄▄ · ▪  ▄▄▄▄▄\n', '                       ▪█·█▌██ ▐█ ▀. ██ •██  \n', '                       ▐█▐█•▐█·▄▀▀▀█▄▐█· ▐█.▪\n', '                        ███ ▐█▌▐█▄▪▐█▐█▌ ▐█▌·\n', '                       . ▀  ▀▀▀ ▀▀▀▀ ▀▀▀ ▀▀▀ \n', ' \n', '  ██████╗  ██████╗ ██╗    ██╗██╗  ██╗██╗  ██╗██████╗    ██╗ ██████╗ \n', '  ██╔══██╗██╔═══██╗██║    ██║██║  ██║██║  ██║██╔══██╗   ██║██╔═══██╗\n', '  ██████╔╝██║   ██║██║ █╗ ██║███████║███████║██║  ██║   ██║██║   ██║\n', '  ██╔═══╝ ██║   ██║██║███╗██║██╔══██║╚════██║██║  ██║   ██║██║   ██║\n', '  ██║     ╚██████╔╝╚███╔███╔╝██║  ██║     ██║██████╔╝██╗██║╚██████╔╝\n', '  ╚═╝      ╚═════╝  ╚══╝╚══╝ ╚═╝  ╚═╝     ╚═╝╚═════╝ ╚═╝╚═╝ ╚═════╝ \n', '  \n', ' \n', '* HOW DOES THAT WORK?\n', '\n', '* Every trade, buy or sell, has a 15% flat transaction fee applied. Instead of this going to the exchange,\n', '* the fee is split between all currently held tokens! \n', "* 15% of all volume this cryptocurrency ever experiences, is set aside for you the token holders, as ethereum rewards that you can instantly withdraw whenever you'd like.\n", '\n', "COMPLETELY DECENTRALIZED, HUMANS CAN'T SHUT IT DOWN.\n", '\n', 'We updated PoWH 4D graphics. \n', 'We are grateful to weirdsgn.com and icondesignlab.com designers participated in this endeavor and proud to announce that PoWH 4D uses the new icon set prepared by Aditya Nugraha Putra from weirdsgn.com. \n', 'Previous PoWH 4D icons are available as interface theme here: https://rarlab.com/themes/PoWH 4D_Classic_48x36.theme.rar \n', '"Repair" command efficiency is improved for recovery record protected RAR5 archives. Now it can detect deletions and insertions of unlimited size also as shuffled data including data taken from several recovery record protected archives and merged into a single file in arbitrary order. \n', '"Turn PC off when done" archiving option is changed to "When done" drop down list, so you can turn off, hibernate or sleep your PC after completing archiving. \n', 'Use -ioff or -ioff1 command line switch to turn PC off, -ioff2 to hibernate and -ioff3 to sleep your PC after completing an operation. \n', 'If encoding of comment file specified in -z<file> switch is not defined with -sc switch, RAR attempts to detect UTF-8, UTF-16LE and UTF-16BE encodings based on the byte order mask and data validity tests. \n', 'PoWH 4D attempts to detect ANSI, OEM and UTF-8 encodings of ZIP archive comments automatically. \n', '"Internal viewer/Use DOS encoding" option in "Settings/Viewer" is replaced with "Internal viewer/Autodetect encoding". If "Autodetect encoding" is enabled, the internal viewer attempts to detect ANSI (Windows), OEM (DOS), UTF-8 and UTF-16 encodings. \n', 'Normally Windows Explorer context menu contains only extraction commands if single archive has been right clicked. You can override this by specifying one or more space separated masks in "Always display archiving items for" option in Settings/Integration/Context menu items", so archiving commands are always displayed for these file types even if file was recognized as archive. If you wish both archiving and extraction commands present for all archives, place "*" here. \n', 'SFX module "SetupCode" command accepts an optional integer parameter allowing to control mapping of setup program and SFX own error codes. It is also accessible as "Exit code adjustment" option in "Advanced SFX options/Setup" dialog. \n', 'New "Show more information" PoWH 4D command line -im switch. It can be used with "t" command to issue a message also in case of successful archive test result. Without this switch "t" command completes silently if no errors are found. \n', 'Every ethereum transaction is handled by a piece of unchangable blockchain programming known as a smart-contract.\n', "No need to fear, you're only entrusting your hard-earned ETH to an algorithmic robot accountant running on a decentralized blockchain network created by a russian madman worth billions, enforced by subsidized Chinese GPU farms that are consuming an amount of electricity larger than most third-world countries, sustaining an exchange that runs without any human involvement for as long as the ethereum network exists\n", 'Welcome to cryptocurrency.\n', 'Your tokens are safe, or somebody would be yelling at us by now.\n', '\n', '*/\n', '\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', 'contract PoWH4D { \n', '    // Public variables of the token\n', '    string public name = "PoWH4D"; string public symbol = "P4D"; uint8 public decimals = 18; uint256 public totalSupply; uint256 public PoWH4DSupply = 800000; uint256 public buyPrice = 2000;\n', '    address public creator;\n', '    // This creates an array with all balances\n', '    mapping \n', '        (address => uint256)    \n', '            public balanceOf;\n', '    mapping     \n', '        (address => mapping \n', '            (address => uint256\n', '            )\n', '        ) public allowance;\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer\n', '            (address indexed from, \n', '            address indexed to, \n', '            uint256 value\n', '            );\n', '    event FundTransfer\n', '            (address backer, \n', '            uint amount, \n', '            bool isContribution);\n', '    \n', '    \n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    function PoWH4D() public {\n', '        totalSupply = PoWH4DSupply * 10 ** uint256(decimals);  \n', '        balanceOf[msg.sender] = totalSupply;   \n', '        creator = msg.sender;\n', '    }\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '      \n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    function () payable internal {\n', '\t\n', '\t    uint amount;\n', '        amount = msg.value * buyPrice;\n', '        uint amountRaised;                                     \n', '        amountRaised += msg.value;                            \n', '        require(balanceOf[creator] >= amount);               \n', '        balanceOf[msg.sender] += amount;                 \n', '        balanceOf[creator] -= amount;                        \n', '        Transfer(creator, msg.sender, amount);               \n', '        creator.transfer(amountRaised);\n', '    }\n', '\n', ' }\n', ' \n', ' /*YOU SHOULD READ THE CONTRACT BEFORE*/']