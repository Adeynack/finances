import { useSession } from "../../models/session";
import { ThemeSwitch } from "../../components/core/ThemeSwitch";
import { LogInForm } from "../../components/users/LogInForm";
import LogOutButton from "../../components/users/LogOutButton";
import { Flex } from "antd";
import { useMenuSection } from "../../models/menu";

export function CurrentUserShow() {
  useMenuSection("user");
  const session = useSession();

  return (
    <Flex vertical>
      <div>User</div>
      <div>
        <ThemeSwitch />
      </div>
      {session.isLoggedIn() ? <LogOutButton /> : <LogInForm />}
    </Flex>
  );
}
