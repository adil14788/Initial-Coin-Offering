require("@nomiclabs/hardhat-waffle");
require("dotenv").config();

const ALCHEMY_API_KEY = process.env.ALCHEMY_API_KEY || "";
const GOERLI_PRIVATE_KEY = process.env.GOERLI_PRIVATE_KEY || "";

module.exports = {
	solidity: "0.8.10",
	networks: {
		goerli: {
			url: ALCHEMY_API_KEY,
			accounts: [GOERLI_PRIVATE_KEY],
		},
	},
};
