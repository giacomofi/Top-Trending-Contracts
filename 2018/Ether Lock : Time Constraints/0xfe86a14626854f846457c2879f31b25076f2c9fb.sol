['pragma solidity ^0.4.24;\n', '/**\n', '* @title -UintCompressor- v0.1.9\n', '* ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐\n', '*  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐\n', '*  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘\n', '*                                  _____                      _____\n', '*                                 (, /     /)       /) /)    (, /      /)          /)\n', '*          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/\n', '*          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_\n', '*          ┴ ┴                /   /          .-/ _____   (__ /                               \n', '*                            (__ /          (_/ (, /                                      /)™ \n', '*                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/\n', '* ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_\n', '* ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  &#169; Jekyll Island Inc. 2018\n', '* ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/\n', '*    _  _   __   __ _  ____     ___   __   _  _  ____  ____  ____  ____  ____   __   ____ \n', '*===/ )( \\ (  ) (  ( \\(_  _)===/ __) /  \\ ( \\/ )(  _ \\(  _ \\(  __)/ ___)/ ___) /  \\ (  _ \\===*\n', '*   ) \\/ (  )(  /    /  )(    ( (__ (  O )/ \\/ \\ ) __/ )   / ) _) \\___ \\\\___ \\(  O ) )   /\n', '*===\\____/ (__) \\_)__) (__)====\\___) \\__/ \\_)(_/(__)  (__\\_)(____)(____/(____/ \\__/ (__\\_)===*\n', '*\n', '* ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐\n', '* ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │\n', '* ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘\n', '*/\n', '\n', 'library UintCompressor {\n', '    using SafeMath for *;\n', '    \n', '    function insert(uint256 _var, uint256 _include, uint256 _start, uint256 _end)\n', '        internal\n', '        pure\n', '        returns(uint256)\n', '    {\n', '        // check conditions \n', '        require(_end < 77 && _start < 77, "start/end must be less than 77");\n', '        require(_end >= _start, "end must be >= start");\n', '        \n', '        // format our start/end points\n', '        _end = exponent(_end).mul(10);\n', '        _start = exponent(_start);\n', '        \n', '        // check that the include data fits into its segment \n', '        require(_include < (_end / _start));\n', '        \n', '        // build middle\n', '        if (_include > 0)\n', '            _include = _include.mul(_start);\n', '        \n', '        return((_var.sub((_var / _start).mul(_start))).add(_include).add((_var / _end).mul(_end)));\n', '    }\n', '    \n', '    function extract(uint256 _input, uint256 _start, uint256 _end)\n', '\t    internal\n', '\t    pure\n', '\t    returns(uint256)\n', '    {\n', '        // check conditions\n', '        require(_end < 77 && _start < 77, "start/end must be less than 77");\n', '        require(_end >= _start, "end must be >= start");\n', '        \n', '        // format our start/end points\n', '        _end = exponent(_end).mul(10);\n', '        _start = exponent(_start);\n', '        \n', '        // return requested section\n', '        return((((_input / _start).mul(_start)).sub((_input / _end).mul(_end))) / _start);\n', '    }\n', '    \n', '    function exponent(uint256 _position)\n', '        private\n', '        pure\n', '        returns(uint256)\n', '    {\n', '        return((10).pwr(_position));\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title SafeMath v0.1.9\n', ' * @dev Math operations with safety checks that throw on error\n', ' * change notes:  original SafeMath library from OpenZeppelin modified by Inventor\n', ' * - added sqrt\n', ' * - added sq\n', ' * - added pwr \n', ' * - changed asserts to requires with error log outputs\n', ' * - removed div, its useless\n', ' */\n', 'library SafeMath {\n', '    \n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) \n', '        internal \n', '        pure \n', '        returns (uint256 c) \n', '    {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        require(c / a == b, "SafeMath mul failed");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b)\n', '        internal\n', '        pure\n', '        returns (uint256) \n', '    {\n', '        require(b <= a, "SafeMath sub failed");\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b)\n', '        internal\n', '        pure\n', '        returns (uint256 c) \n', '    {\n', '        c = a + b;\n', '        require(c >= a, "SafeMath add failed");\n', '        return c;\n', '    }\n', '    \n', '    /**\n', '     * @dev gives square root of given x.\n', '     */\n', '    function sqrt(uint256 x)\n', '        internal\n', '        pure\n', '        returns (uint256 y) \n', '    {\n', '        uint256 z = ((add(x,1)) / 2);\n', '        y = x;\n', '        while (z < y) \n', '        {\n', '            y = z;\n', '            z = ((add((x / z),z)) / 2);\n', '        }\n', '    }\n', '    \n', '    /**\n', '     * @dev gives square. multiplies x by x\n', '     */\n', '    function sq(uint256 x)\n', '        internal\n', '        pure\n', '        returns (uint256)\n', '    {\n', '        return (mul(x,x));\n', '    }\n', '    \n', '    /**\n', '     * @dev x to the power of y \n', '     */\n', '    function pwr(uint256 x, uint256 y)\n', '        internal \n', '        pure \n', '        returns (uint256)\n', '    {\n', '        if (x==0)\n', '            return (0);\n', '        else if (y==0)\n', '            return (1);\n', '        else \n', '        {\n', '            uint256 z = x;\n', '            for (uint256 i=1; i < y; i++)\n', '                z = mul(z,x);\n', '            return (z);\n', '        }\n', '    }\n', '}']