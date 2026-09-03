package vn.iotstar.util;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;
public class PasswordUtilTest {
  @Test void hashAndCheck() {
    String hash = PasswordUtil.hash("123");
    assertNotEquals("123", hash);
    assertTrue(PasswordUtil.check("123", hash));
    assertFalse(PasswordUtil.check("wrong", hash));
  }
  @Test void hashIsDifferentEachTime() {
    assertNotEquals(PasswordUtil.hash("123"), PasswordUtil.hash("123"));
  }
}
